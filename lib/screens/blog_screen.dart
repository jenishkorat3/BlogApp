import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jkblog/blocs/auth_bloc/auth_bloc.dart';
import 'package:jkblog/widgets/widget.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Screen'),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/addBlog');
              },
              child: const Icon(Icons.add)),
          const SizedBox(width: 15),
          InkWell(
              onTap: () {
                context.read<AuthBloc>().add(AuthSignOut());
              },
              child: const Icon(Icons.logout)),
          const SizedBox(width: 10),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          }
          if (state is AuthFailure) {
            showSnackBar(context, Colors.red, state.error);
          }
        },
        builder: (context, state) {
          if (state is AuthSLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
          return const Text("Blogs");
        },
      ),
    );
  }
}