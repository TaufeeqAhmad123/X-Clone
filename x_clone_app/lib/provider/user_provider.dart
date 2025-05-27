import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/Auth/repository/user_repository.dart';
import 'package:x_clone_app/model/commentModel.dart';
import 'package:x_clone_app/model/postModel.dart';
import 'package:x_clone_app/model/user_model.dart';
import 'package:x_clone_app/service/cloude_messaging_service.dart';
import 'package:x_clone_app/utils/Snackbar/snackbar.dart';

class Userprovider with ChangeNotifier {
  UserModel? userModel;
  String? _postImageUrl;
  String? _profileImageUrl;
  File? imageFile, profileImage;

  final _auth = AuthenticationRepository();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final _db = UserRepository();

  //get user data from firebase
  UserModel? _user;
  UserModel? get user => _user;

  Future<UserModel?> loadUSerData(String uid) async {
    _user = await _db.getUserDetails(uid);
    notifyListeners(); // This notifies the ProfileScreen
    return _user;
  }

  Future<void> updateUserProfile(String currentuserId, name, bio) async {
    await _db.updateUserProfile(currentuserId, name, _profileImageUrl, bio);
    await loadUSerData(currentuserId);
    notifyListeners();
  }

  //searcxh user by in firebase
  List<UserModel> _searchUserList = [];
  List<UserModel> get searchUserList => _searchUserList;
  Future<void> searchUser(String searchitem) async {
    try {
      final result = await _db.searchuserInFirebase(searchitem);
      // _searchUserList = users.where((user) {
      //   // Filter out blocked users
      //   return !_blockUser.any((blockedUser) => blockedUser.uid == user.uid);
      // }).toList();
      _searchUserList = result;
      notifyListeners();
    } catch (e) {
      print('error in search user $e');
    }
  }

  List<Postmodel> _postsList = [];
  List<Postmodel> _followingPost = [];

  List<Postmodel> get postsList => _postsList;
  List<Postmodel> get folloeingPost => _followingPost;
  //store Post messegae to firebase
  Future<void> postMessage(String message) async {
    await _db.storePostInFirebase(message, imageURL: _postImageUrl ?? "");
    await getAllPostFromFirebase();
  }

  //get all the post from firebase
  Future<void> getAllPostFromFirebase() async {
    final postsList = await _db.getAllPost();
    _postsList = postsList.where((post) {
      // Filter out posts from blocked users
      return !_blockUser.any((blockedUser) => blockedUser.uid == post.uid);
    }).toList();
    //_postsList = postsList;
    initializedLikeCounts();
    await getFollowingUserPost();
    notifyListeners();
  }

  //get all the post for single user

  List<Postmodel> getAllPostForSingleuser(String uid) {
    return _postsList.where((post) => post.uid == uid).toList();
  }

  //get post for following user
  Future<void> getFollowingUserPost() async {
    String currentId = AuthenticationRepository().getCurrentUid();

    final followingIds = await _db.getFollowinguserfromFirebase(currentId);
    _followingPost = postsList.where((post) {
      return followingIds.contains(post.uid) &&
          !_blockUser.any((blockedUser) => blockedUser.uid == post.uid);
    }).toList();
    notifyListeners();
  }

  //get all the post for single user
  Future<void> deletepost(String postID) async {
    await _db.deletePostFromFirebase(postID);
    await getAllPostFromFirebase();
  }

  //store the like count in the map
  Map<String, int> _likeCounts = {};
  List<String> _likePost = [];
  bool isCurrentsUserLikePost(String postID) {
    return _likePost.contains(postID);
  }

  int getLikeCount(String postID) => _likeCounts[postID] ?? 0;
  //
  void initializedLikeCounts() {
    final currentuserID = AuthenticationRepository().getCurrentUid();
    _likePost.clear();
    for (var post in _postsList) {
      _likeCounts[post.id] = post.likecounts;
      if (post.likeBY.contains(currentuserID)) {
        _likePost.add(post.id);
      }
    }
  }
  //like the post

  Future<void> likePost(String postID) async {
    final likeCountOriginal = _likeCounts;
    final likePostOriginal = _likePost;
    if (_likePost.contains(postID)) {
      _likePost.remove(postID);
      _likeCounts[postID] = (_likeCounts[postID] ?? 0) - 1;
    } else {
      _likePost.add(postID);
      _likeCounts[postID] = (_likeCounts[postID] ?? 0) + 1;
    }
    notifyListeners();

    try {
      await _db.toggleLikeInFirebase(postID);
    } catch (e) {
      _likeCounts = likeCountOriginal;
      _likePost = likePostOriginal;
      notifyListeners();
    }
  }

  //postid,comments
  //in map the string will store id and list will store the comments
  final Map<String, List<Commentmodel>> _comments = {};
  List<Commentmodel> getComments(String postID) => _comments[postID] ?? [];

  Future<void> loadcomments(String postID) async {
    final allCommnets = await _db.getCommentsfromFirebase(postID);
    _comments[postID] = allCommnets;
    notifyListeners();
  }

  //store comments in the post
  Future<void> storeCommentInFirebase(String postID, String comment) async {
    await _db.commentOnPost(postID, comment);
    //get post id 
    Postmodel? post = _postsList.firstWhere(
      (post) => post.id == postID,
      orElse: () => Postmodel.empty(),
    );
    //curent user id
    var currentUserId = AuthenticationRepository().getCurrentUid();
    //get current user detail
    var commenter = await _db.getUserDetails(currentUserId);
    //get current use deatil which will show on notification 
    String commenterName = commenter?.name ?? "Someone";
    //get the post owner detail
    var postowner = await _db.getUserDetails(post.uid);
    //get the FCM token of the post owner
    var FCMToken = postowner?.FCMToken;
    if (FCMToken == null || FCMToken!.isEmpty) {
      print('FCM Token is null or empty');
    }
    final get = getCloudeMessagingService();
    String token = await get.serverToken();
    await http.post(
      Uri.parse(
        'https://fcm.googleapis.com/v1/projects/xclone-af992/messages:send',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        "message": {
          "token": FCMToken, // Use the FCM token of the post owner
          "notification": {
            "title": "New Comment from $commenterName",
            "body": comment,
          },
          "data": {
            "type": "comment",
            "postID": postID,
            "commenterID": currentUserId,
            "comment": comment,
          },
        },
      }),
    );

    await loadcomments(postID);
  }

  Future<void> deleteCommets(String commentID, String postID) async {
    await _db.deletecommentOnPost(commentID);
    await loadcomments(postID);
  }

  List<UserModel> _blockUser = [];
  List<UserModel> get blockUser => _blockUser;
  //get all the block user from firebase
  Future<void> loadBlockUserID() async {
    final allBlockUserIDs = await _db.getblockUserFromFirebase();
    final blockuserData = await Future.wait(
      allBlockUserIDs.map((id) => _db.getUserDetails(id)),
    );
    _blockUser = blockuserData.whereType<UserModel>().toList();
    notifyListeners();
  }

  Future<void> blockUserinFirebase(String userId) async {
    await _db.blockuser(userId);
    // remove blocked user's posts
    await loadBlockUserID();
    await getAllPostFromFirebase();
    notifyListeners();
  }

  Future<void> unblockUserfromFirebase(String userId) async {
    await _db.Unblockuser(userId);

    await loadBlockUserID();
    await getAllPostFromFirebase();
    notifyListeners();
  }

  Future<void> reportUser(String userId, postId) async {
    await _db.repostUser(userId, postId);
  }
  //get follwers and following
  // each user id  have list of follower id and floowing id
  // eg uid: [list of folloer and following]

  Map<String, List<String>> _followers = {};
  Map<String, List<String>> _following = {};

  final Map<String, int> _followersCount = {};
  final Map<String, int> _followingCount = {};

  int getFollowersCount(String uid) => _followersCount[uid] ?? 0;
  int getFollowingCount(String uid) => _followingCount[uid] ?? 0;

  // load followers
  Future<void> loadFollowers(String uid) async {
    final listofFollowersuid = await _db.getFollowersfromFirebase(uid);

    _followers[uid] = listofFollowersuid;
    _followersCount[uid] = listofFollowersuid.length;

    notifyListeners();
  }

  // load following
  Future<void> loadFollowings(String uid) async {
    final listofFollowingsuid = await _db.getFollowinguserfromFirebase(uid);

    _following[uid] = listofFollowingsuid;
    _followingCount[uid] = listofFollowingsuid.length;

    notifyListeners();
  }

  //load follow uer

  Future<void> followUser(String targetUserId) async {
    final currentUserId = _auth.getCurrentUid();
    //initaialize the list = null
    _followers.putIfAbsent(targetUserId, () => []);
    _following.putIfAbsent(currentUserId, () => []);
    //follow if the user is not already following
    //we are doing it loacaly..... folloing user and followers after it we will upload it to firebase
    //this is call optimistic update change it localy then upload it to firebase

    if (!_followers[targetUserId]!.contains(currentUserId)) {
      _followers[targetUserId]!.add(currentUserId);
      _following[currentUserId]!.add(targetUserId);
      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 0) + 1;
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) + 1;
      notifyListeners();
    }
    notifyListeners();

    try {
      //store the following and follower in firebase
      await _db.followuserInFirebase(targetUserId).then((value) {
        SnackbarUtil.successSnackBar(title: 'Success', message: 'Followed');
      });

      await loadFollowers(currentUserId);
      await loadFollowings(currentUserId);
    } catch (e) {
      //if something bad occure mean data didnot store in firebase so remove the data from the map
      _followers[targetUserId]!.remove(currentUserId);
      _following[currentUserId]!.remove(targetUserId);
      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 1) - 1;
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 1) - 1;
      notifyListeners();
    }
  }

  Future<void> unfollowUser(String targetUserId) async {
    final currentUserId = _auth.getCurrentUid();
    //initaialize the list = null
    _followers.putIfAbsent(targetUserId, () => []);
    _following.putIfAbsent(currentUserId, () => []);
    //follow if the user is not already following
    //we are doing it loacaly..... folloing user and followers after it we will upload it to firebase
    //this is call optimistic update change it localy then upload it to firebase
    if (_followers[targetUserId]!.contains(currentUserId)) {
      _followers[targetUserId]?.remove(currentUserId);
      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 1) - 1;
      _following[currentUserId]?.remove(targetUserId);
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 1) - 1;
    }
    notifyListeners();

    try {
      //store the following and follower in firebase
      await _db.unfollowuserInFirebase(targetUserId);

      await loadFollowers(currentUserId);
      await loadFollowings(currentUserId);
    } catch (e) {
      //if something bad occure mean data didnot store in firebase so remove the data from the map
      _followers[targetUserId]?.add(currentUserId);
      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 0) + 1;
      _following[currentUserId]?.add(targetUserId);
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) + 1;
      notifyListeners();
    }
  }
  //load unfollow user

  //check is current user is following the user
  Future<bool> fetchIsCurrentUserFollowing(String uid) async {
    final currentUserId = _auth.getCurrentUid();
    final followers = await _db.getFollowersfromFirebase(uid);
    return followers.contains(currentUserId);
  }

  //list of followers profile
  Map<String, List<UserModel>> _followersProfile = {};
  Map<String, List<UserModel>> _followingProfile = {};
  List<UserModel> getListOfFollowersProfile(String uid) =>
      _followersProfile[uid] ?? [];
  List<UserModel> getListOfFollowingProfile(String uid) =>
      _followingProfile[uid] ?? [];
  //load followers profile

  Future<void> loadFollowersProfile(String uid) async {
    try {
      final folloersids = await _db.getFollowersfromFirebase(uid);
      List<UserModel> followersProfile = [];
      for (String id in folloersids) {
        UserModel? user = await _db.getUserDetails(id);
        if (user != null) {
          followersProfile.add(user);
        }
      }
      _followersProfile[uid] = followersProfile;
      notifyListeners();
    } catch (e) {
      print('error in loading following profile $e');
    }
  }

  Future<void> loadFollowingProfile(String uid) async {
    try {
      final followingids = await _db.getFollowinguserfromFirebase(uid);
      List<UserModel> followingProfile = [];
      for (String id in followingids) {
        UserModel? user = await _db.getUserDetails(id);
        if (user != null) {
          followingProfile.add(user);
        }
      }
      _followingProfile[uid] = followingProfile;
      notifyListeners();
    } catch (e) {
      print('error in loading following profile $e');
    }
  }

  Future<void> logout() async {
    await AuthenticationRepository().Logout();
    notifyListeners();
  }

  Future<void> pickimage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxHeight: 512,
      maxWidth: 512,
    );
    if (image != null) {
      imageFile = File(image.path);
      notifyListeners();
      final url = await _db.uploadImageToSupabase(imageFile!);
      _postImageUrl = url;

      imageFile = null;

      notifyListeners();
      print('image url is $url');
    }
  }

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxHeight: 512,
      maxWidth: 512,
    );
    if (image != null) {
      profileImage = File(image.path);
      notifyListeners();
      final url = await _db.uploadprofileImageToSupabase(profileImage!);
      _profileImageUrl = url;

      // imageFile = null;

      notifyListeners();
      // print('image url is $url');
    }
  }
}
