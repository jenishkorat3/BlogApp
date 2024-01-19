import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jkblog/blocs/splash_screen_bloc/splash_screen_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = FirebaseAuth.instance;
  bool isUser = false;
  @override
  void initState() {
    super.initState();

    final user = _auth.currentUser;
    if (user != null) {
      isUser = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<SplashScreenBloc, SplashScreenState>(
        listener: (context, state) {
          if (state is NavigateTo) {
            if (isUser) {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(context, '/register', (route) => false);
            }
          }
        },
        builder: (context, state) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image(
                  image: AssetImage('images/logo.png'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
