import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jkblog/blocs/add_blog_bloc/add_blog_bloc.dart';
import 'package:jkblog/blocs/auth_bloc/auth_bloc.dart';
import 'package:jkblog/blocs/home_bloc/home_bloc.dart';
import 'package:jkblog/blocs/splash_screen_bloc/splash_screen_bloc.dart';
import 'package:jkblog/firebase_options.dart';
import 'package:jkblog/screens/add_blog_screen.dart';
import 'package:jkblog/screens/blog_screen.dart';
import 'package:jkblog/screens/home_screen.dart';
import 'package:jkblog/screens/login_screen.dart';
import 'package:jkblog/screens/profile_screen.dart';
import 'package:jkblog/screens/register_screen.dart';
import 'package:jkblog/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplashScreenBloc()..add(InitializeApp())),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => AddBlogBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepOrange,
        ),
        home: const SplashScreen(),
        initialRoute: "/",
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/blog' : (context) => const BlogScreen(),
          '/profile' : (context) => ProfileScreen(),
          '/addBlog': (context) => AddBlogScreen(),
        },
      ),
    );
  }
}
