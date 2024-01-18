part of 'delete_blog_bloc.dart';

sealed class DeleteBlogState {}

final class DeleteBlogInitialState extends DeleteBlogState {}

final class DeleteBlogLoading extends DeleteBlogState {}

final class BlogDeletetedSuccessfully extends DeleteBlogState {}

final class BlogNotDeletetedSuccessfully extends DeleteBlogState {
  final String error;

  BlogNotDeletetedSuccessfully({required this.error});
}
