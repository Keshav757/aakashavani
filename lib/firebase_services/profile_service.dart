import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Uploads profile image to Firebase Storage and returns the download URL
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return null;

      final ref = _storage.ref().child('profile_images/$uid.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Image upload failed: $e");
      return null;
    }
  }

  /// Saves name and profileImageUrl to Firestore
  Future<void> saveUserProfile({required String name, String? imageUrl}) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'profileImageUrl': imageUrl ?? '',
        'phone': _auth.currentUser?.phoneNumber ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      print("Error saving user profile: $e");
      // ❌ remove this unless you want the UI to stop
      // rethrow;
    }
  }
}
