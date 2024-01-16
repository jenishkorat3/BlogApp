// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_blog_bloc.dart';

sealed class AddBlogInitialEvent {}

class PickedImage extends AddBlogInitialEvent {
  final ImageSource source;
  PickedImage({
    required this.source,
  });
}

class AddBlog extends AddBlogInitialEvent {
  final File? image;
  final String title;
  final String description;

  AddBlog({
    required this.image,
    required this.title,
    required this.description,
  });
}