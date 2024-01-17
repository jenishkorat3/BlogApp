import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jkblog/blocs/add_blog_bloc/add_blog_bloc.dart';

void dialog(context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: SizedBox(
          height: 120,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  context.read<AddBlogBloc>().add(PickedImage(source: ImageSource.camera));
                  Navigator.pop(context);
                },
                child: const ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Camera'),
                ),
              ),
              InkWell(
                onTap: () {
                  context.read<AddBlogBloc>().add(PickedImage(source: ImageSource.gallery));
                  Navigator.pop(context);
                },
                child: const ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
