import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jkblog/blocs/add_blog_bloc/add_blog_bloc.dart';
import 'package:jkblog/widgets/add_blog_dialoge_box.dart';
import 'package:jkblog/widgets/widget.dart';

// ignore: must_be_immutable
class AddBlogScreen extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? image;
  final picker = ImagePicker();

  AddBlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Blogs'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocConsumer<AddBlogBloc, AddBlogState>(
        listener: (context, state) {
          if (state is ImageisNotSelected) {
            showSnackBar(context, Colors.red, state.error);
          }
          if (state is BlogAddedSuccessfully) {
            showSnackBar(context, Colors.green, state.message);
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
          if (state is BlogNotAddedSuccessfully) {
            showSnackBar(context, Colors.red, state.error);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      dialog(context);
                    },
                    child: Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 1,
                        child: BlocBuilder<AddBlogBloc, AddBlogState>(builder: (context, state) {
                          if (state is ImageisSelected) {
                            image = state.image;
                            return ClipRRect(
                              child: Image.file(
                                image!.absolute,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 100,
                            height: 100,
                            child: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: titleController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Enter blog title',
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: TextFormField(
                            controller: descriptionController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: 'Enter blog description',
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.read<AddBlogBloc>().add(AddBlog(
                                  image: image,
                                  title: titleController.text.toString(),
                                  description: descriptionController.text.toString(),
                                ));
                          },
                          child: BlocBuilder<AddBlogBloc, AddBlogState>(
                            builder: (context, state) {
                              if (state is BlogLoading) {
                                return Container(
                                  height: 45,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                );
                              }

                              return Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.deepOrange, Color.fromARGB(255, 246, 158, 132)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                height: 45,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Upload',
                                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
