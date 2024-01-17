import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jkblog/services/database_services.dart';

part 'add_blog_event.dart';
part 'add_blog_state.dart';

class AddBlogBloc extends Bloc<AddBlogInitialEvent, AddBlogState> {
  final picker = ImagePicker();

  AddBlogBloc() : super(AddBlogInitial()) {
    on<PickedImage>(_onPickedImage);

    on<AddBlog>(_onAddBlog);
  }

  void _onPickedImage(PickedImage event, Emitter<AddBlogState> emit) async {
      try {
        final pickedImage = await picker.pickImage(
          source: event.source,
          imageQuality: 80,
        );

        if (pickedImage != null) {
          emit(ImageisSelected(image: File(pickedImage.path)));
        } else {
          emit(ImageisNotSelected(error: 'Image is not selected!'));
        }
      } catch (e) {
        emit(ImageisNotSelected(error: e.toString()));
      }
    }

    void _onAddBlog(AddBlog event, Emitter<AddBlogState> emit) async {
      emit(BlogLoading());
      try {
        await DatabaseService().uploadBlog(event.image, event.title, event.description).then((value) {
          if (value != null) {
            emit(BlogAddedSuccessfully(message: 'Blog added Successfully.'));
          } else {
            emit(BlogNotAddedSuccessfully(error: value.toString()));
          }
        });
      } catch (e) {
        emit(BlogNotAddedSuccessfully(error: e.toString()));
      }
    }

  @override
  void onChange(Change<AddBlogState> change) {
    super.onChange(change);
    print(change);
  }
}