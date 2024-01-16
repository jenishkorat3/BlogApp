import 'dart:async';
import 'package:bloc/bloc.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitialState()) {
    on<InitializeApp>((event, emit) async {
      try {
        await Future.delayed(const Duration(seconds: 3), () => emit(NavigateTo()));
      } catch (e) {
        e.toString();
      }
    });
  }
}
