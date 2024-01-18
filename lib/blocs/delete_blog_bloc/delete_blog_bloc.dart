import 'package:bloc/bloc.dart';
import 'package:jkblog/services/database_services.dart';

part 'delete_blog_event.dart';
part 'delete_blog_state.dart';

class DeleteBlogBloc extends Bloc<DeleteBlogInitialEvent, DeleteBlogState> {
  DeleteBlogBloc() : super(DeleteBlogInitialState()) {
    on<DeleteBlog>((event, emit) async {
      emit((DeleteBlogLoading()));
      try {
        await DatabaseService().deleteBlog(event.bid).then((value) {
          if (value) {
            emit(BlogDeletetedSuccessfully());
          } else {
            emit(BlogNotDeletetedSuccessfully(error: value.toString()));
          }
        });
      } catch (e) {
        emit(BlogNotDeletetedSuccessfully(error: e.toString()));
      }
    });
  }

  @override
  void onChange(Change<DeleteBlogState> change) {
    super.onChange(change);
    print(change.toString());
  }
}
