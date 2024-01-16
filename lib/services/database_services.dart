import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DatabaseService {
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final blogRef = FirebaseDatabase.instance.ref().child('Blogs');

  Future uploadBlog(File? image, String title, String description) async {
    try {
      int date = DateTime.now().millisecondsSinceEpoch;

      ///Image Upload
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/jkblog-$date');
      firebase_storage.UploadTask uploadTask = ref.putFile(image!.absolute);
      await Future.value(uploadTask);

      String? imageUrl = await ref.getDownloadURL();

      final User? user = auth.currentUser;

      //Blog Upload
      blogRef.child('Blogs List').child(date.toString()).set({
        'bid': date.toString(),
        'bImage': imageUrl.toString(),
        'bTime': date.toString(),
        'bTitle': title,
        'bDescription': description,
        'uEmail': user!.email.toString(),
        'uid': user.uid.toString(),
      });
      return true;
    } catch (e) {
      return e;
    }
  }
}