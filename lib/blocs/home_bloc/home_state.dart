part of 'home_bloc.dart';


sealed class HomeState {}

final class HomeInitial extends HomeState {}

class BlogsScreenState extends HomeState {}

class ProfileScreenState extends HomeState {}