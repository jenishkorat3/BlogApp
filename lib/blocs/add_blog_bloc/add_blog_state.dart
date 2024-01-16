part of 'add_blog_bloc.dart';

sealed class AddBlogState {}

final class AddBlogInitial extends AddBlogState {}

final class ImageisSelected extends AddBlogState {
  final File image;
  ImageisSelected({
    required this.image,
  });
}

final class ImageisNotSelected extends AddBlogState {
  final String error;
  ImageisNotSelected({required this.error});
}

final class BlogAddedSuccessfully extends AddBlogState {
  final String message;

  BlogAddedSuccessfully({required this.message});
}

final class BlogNotAddedSuccessfully extends AddBlogState {
  final String error;

  BlogNotAddedSuccessfully({required this.error});
}

class BlogLoading extends AddBlogState{}