import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jkblog/blocs/auth_bloc/auth_bloc.dart';
import 'package:jkblog/widgets/blog_widget.dart';
import 'package:jkblog/widgets/widget.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  final dbRef = FirebaseDatabase.instance.ref().child('Blogs');
  final auth = FirebaseAuth.instance;
  String email = '';

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          auth.currentUser!.email.toString().substring(0, auth.currentUser!.email.toString().indexOf("@")),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          InkWell(
              onTap: () {
                context.read<AuthBloc>().add(AuthSignOut());
              },
              child: const Icon(Icons.logout)),
          const SizedBox(width: 15),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          }
          if (state is AuthFailure) {
            showSnackBar(context, Colors.red, state.error);
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: FirebaseAnimatedList(
                        query: dbRef.child('Blogs List'),
                        itemBuilder: (BuildContext context, snapshot, Animation<double> animation, int index) {
                          if (snapshot.child('uid').value.toString() == auth.currentUser!.uid) {
                            return  Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10, top: 15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'My Blogs:',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                  ),
                                ),
                            blogsCard(context, snapshot, "You"),
                              ],
                            );
                          } else {
                            return Container();
                          }

                          // if(snapshot.hasChild(('uid').value.toString() == auth.currentUser!.uid))
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}