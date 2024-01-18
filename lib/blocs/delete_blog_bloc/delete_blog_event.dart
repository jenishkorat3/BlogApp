part of 'delete_blog_bloc.dart';

sealed class DeleteBlogInitialEvent {}

class DeleteBlog extends DeleteBlogInitialEvent {
  final String bid;

  DeleteBlog({required this.bid});
}
