import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jkblog/blocs/auth_bloc/auth_bloc.dart';
import 'package:jkblog/widgets/blog_widget.dart';
import 'package:jkblog/widgets/widget.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

// ignore: must_be_immutable
class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final dbRef = FirebaseDatabase.instance.ref().child('Blogs');
  final auth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
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

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search with blog title',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: FirebaseAnimatedList(
                    defaultChild: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ), //shimmerblogsCard(context),
                    query: dbRef.child('Blogs List'),
                    itemBuilder: (BuildContext context, snapshot, Animation<double> animation, int index) {
                      String uEmail = snapshot.child('uEmail').value.toString();
                      String tempTitle = snapshot.child('bTitle').value.toString();
                      if(snapshot.exists){
                        if (searchController.text.isEmpty) {
                        return blogsCard(context, snapshot, uEmail, "blog_screen");
                      } else if (tempTitle.toLowerCase().contains(searchController.text.toString())) {
                        return blogsCard(context, snapshot, uEmail, "blog_screen");
                      } else {
                        return Container();
                      }
                      }
                      else{
                        return const Text("Uh oh... There is no blogs");
                      }
                      
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
