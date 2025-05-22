import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/Auth/repository/user_repository.dart';
import 'package:x_clone_app/model/commentModel.dart';
import 'package:x_clone_app/model/postModel.dart';
import 'package:x_clone_app/model/user_model.dart';

class Userprovider with ChangeNotifier {
  UserModel? userModel;
  String? _postImageUrl;
  File? imageFile;
  final _auth = AuthenticationRepository();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final _db = UserRepository();

  //get user data from firebase
  Future<UserModel?> loadUSerData(String uid) => _db.getUserDetails(uid);

  List<Postmodel> _postsList = [];
  List<Postmodel> get postsList => _postsList;
  //store Post messegae to firebase
  Future<void> postMessage(String message) async {
    await _db.storePostInFirebase(message, imageURL: _postImageUrl ?? "");
    await getAllPostFromFirebase();
  }

  //get all the post from firebase
  Future<void> getAllPostFromFirebase() async {
    final postsList = await _db.getAllPost();
    _postsList = postsList;
    initializedLikeCounts();
    notifyListeners();
  }

  //get all the post for single user

  List<Postmodel> getAllPostForSingleuser(String uid) {
    return _postsList.where((post) => post.uid == uid).toList();
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

  Future<void> pickimage() async {
    final ImagePicker picker=ImagePicker();
    final XFile? image=await picker.pickImage(  source: ImageSource.gallery,
      imageQuality: 70,
      maxHeight: 512,
      maxWidth: 512);
    if(image!=null){
      imageFile=File(image.path);
      notifyListeners();
        final url= await _db.uploadImageToSupabase(imageFile!);
    _postImageUrl=url;

     imageFile = null;
    
    notifyListeners();
   print('image url is $url');
    }
   
    
  }
 
  
}
