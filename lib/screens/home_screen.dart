import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jkblog/blocs/home_bloc/home_bloc.dart';
import 'package:jkblog/screens/blog_screen.dart';
import 'package:jkblog/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: state is BlogsScreenState ? const BlogScreen() : ProfileScreen(),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              if (index == 0) {
                context.read<HomeBloc>().add(BlogsTabSelected());
              } else if (index == 1) {
                context.read<HomeBloc>().add(ProfileTabSelected());
              }
            },
            currentIndex: state is BlogsScreenState ? 0 : 1,
            selectedItemColor: Theme.of(context).primaryColor,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Blogs'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Blogs'),
            ],
          ),
        );
      },
    );
  }
}
