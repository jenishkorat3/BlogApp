part of 'splash_screen_bloc.dart';

sealed class SplashScreenState {}

final class SplashScreenInitialState extends SplashScreenState {}

final class NavigateToHome extends SplashScreenState {}