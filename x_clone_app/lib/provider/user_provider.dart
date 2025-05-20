
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:x_clone_app/Auth/repository/authentication_repository.dart';
import 'package:x_clone_app/Auth/repository/user_repository.dart';
import 'package:x_clone_app/model/commentModel.dart';
import 'package:x_clone_app/model/postModel.dart';
import 'package:x_clone_app/model/user_model.dart';

class Userprovider with ChangeNotifier {
  UserModel? userModel;
  String? _postImageUrl;
  File? selectedImage;
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
   final blockuserData=await Future.wait(allBlockUserIDs.map((id)=>_db.getUserDetails(id)));
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
}



  // Future<void> uploadPostImage() async {
  //   final image = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 70,
  //     maxHeight: 512,
  //     maxWidth: 512,
  //   );
  //   if (image != null) {
  //     selectedImage = File(image.path);
  //     notifyListeners();
  //     // final uploadImage=await _db.uploadPostImage('Posts', image);
  //     //  _postImageUrl = uploadImage;
  //   }
  // }

  // Future<void>uploadPostImage()async{
  //   final image=await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70, maxHeight: 512, maxWidth: 512);
  //   if(image!=null){
  //    selectedImage=File(image.path);
  //     notifyListeners();
  //    // final uploadImage=await _db.uploadPostImage('Posts', image);
  //    //  _postImageUrl = uploadImage;

  //   }

  // }

  // 🚀 Upload to imgbb and Firestore
  // Future<void> postToFirestore(String message) async {
  //   if (selectedImage == null) {
  //     debugPrint("No image selected");
  //     return;
  //   }

  //   final apiKey =
  //       'd9a2b3a1da30c0ab3eb1984a38bcd40d'; // 🔐 Replace with your imgbb key
  //   final url = Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey');

  //   final request = http.MultipartRequest('POST', url);
  //   request.files.add(
  //     await http.MultipartFile.fromPath('image', selectedImage!.path),
  //   );

  //   final response = await request.send();
  //   if (response.statusCode == 200) {
  //     final resStr = await response.stream.bytesToString();
  //     final resJson = jsonDecode(resStr);
  //     _postImageUrl = resJson['data']['url']; // ✅ assign to class field
  //     print('Here is the image URL: $_postImageUrl');

  //     // ✅ Save to Firestore

  //     debugPrint("Post uploaded successfully!");
  //   } else {
  //     debugPrint("Image upload failed with status: ${response.statusCode}");
  //   }
  // // }
  

