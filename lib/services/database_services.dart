import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DatabaseService {
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final blogRef = FirebaseDatabase.instance.ref().child('Blogs');
  final userRef = FirebaseDatabase.instance.ref().child('Users');

  Future storeUserData(String fullName, String email) async {
    try {
      User? user = auth.currentUser;

      // Store user data in the database
      await userRef.child('Users List').child(user!.uid).set({
        'uid': user.uid,
        'fullName': fullName,
        'email': email,
        'blogs': [], // Initially an empty list of blogs
      });
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future uploadBlog(File? image, String title, String description) async {
    try {
      User? user = auth.currentUser;
      int date = DateTime.now().millisecondsSinceEpoch;

      ///Image Upload
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/jkblog-$date');
      firebase_storage.UploadTask uploadTask = ref.putFile(image!.absolute);
      await Future.value(uploadTask);

      String? imageUrl = await ref.getDownloadURL();

      String blogId = date.toString();

      //Blog Upload
      blogRef.child('Blogs List').child(blogId).set({
        'bid': blogId,
        'bImage': imageUrl.toString(),
        'bTime': date.toString(),
        'bTitle': title,
        'bDescription': description,
        'uEmail': user!.email.toString(),
        'uid': user.uid.toString(),
      });

      // Add the blogId to the user's list of blogs
      DatabaseReference userBlogsRef = userRef.child('Users List').child(user.uid).child('blogs');
      await userBlogsRef.child(blogId).set(
        // true
      {
        'bTitle': title,
        'bDescription': description,
        'bImage': imageUrl.toString(),
      }
      );

      return true;
    } catch (e) {
      return e;
    }
  }

  Future deleteBlog(String blogId) async {
    try {
      // Get the reference to the blog in the database
      DatabaseReference blogReference = blogRef.child('Blogs List').child(blogId);

      // Get the blog data to retrieve the image URL
      DatabaseEvent blogEvent = await blogReference.once();
      DataSnapshot blogSnapshot = blogEvent.snapshot;

      if (blogSnapshot.value != null) {
        // Delete the blog entry from the database
        await blogReference.remove();

        // Delete the blog image from Firebase Storage
        String imageUrl = blogSnapshot.child('bImage').value.toString();
        firebase_storage.Reference imageReference = storage.refFromURL(imageUrl);

        await imageReference.delete();

        User? user = auth.currentUser;

        // Reference to the user's list of blogs
        DatabaseReference userBlogsRef = userRef.child('Users List').child(user!.uid).child('blogs');

        // Remove the blog ID from the user's list of blogs
        await userBlogsRef.child(blogId).remove();
      }

      return true;
    } catch (e) {
      return e;
    }
  }
}
