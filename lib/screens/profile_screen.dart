import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jkblog/blocs/auth_bloc/auth_bloc.dart';
import 'package:jkblog/blocs/delete_blog_bloc/delete_blog_bloc.dart';
import 'package:jkblog/screens/full_image_screen.dart';
import 'package:jkblog/widgets/widget.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  final dbRef = FirebaseDatabase.instance.ref().child('Blogs');
  final auth = FirebaseAuth.instance;

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
          if (state is BlogDeletetedSuccessfully) {
            showSnackBar(context, Colors.green, "Blog deleted successfully!");
          }
        },
        child: BlocConsumer<DeleteBlogBloc, DeleteBlogState>(
          listener: (context, state) {
            if (state is BlogDeletetedSuccessfully) {
              showSnackBar(context, Colors.green, "Blog deleted successfully!");
            }
            if (state is BlogNotDeletetedSuccessfully) {
              showSnackBar(context, Colors.red, state.error);
            }
          },
          builder: (context, state) {
            if (state is DeleteBlogLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10, top: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'My Blog:',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                        Expanded(
                          child: FirebaseAnimatedList(
                            query: dbRef.child('Blogs List'),
                            defaultChild: Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            itemBuilder: (BuildContext context, snapshot, Animation<double> animation, int index) {
                              if (snapshot.child('uid').value.toString() == auth.currentUser!.uid) {
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => FullImageScreen(
                                                    blogImageUrl: snapshot.child('bImage').value.toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context).size.width * 1,
                                              height: MediaQuery.of(context).size.height * 0.3,
                                              imageUrl: snapshot.child('bImage').value.toString(),
                                              placeholder: (context, url) => Shimmer.fromColors(
                                                baseColor: Colors.grey[500]!,
                                                highlightColor: Colors.grey[200]!,
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width * 1,
                                                  height: MediaQuery.of(context).size.height * 0.3,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            snapshot.child('bTitle').value.toString(),
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            snapshot.child('bDescription').value.toString(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                                onTap: () {
                                                  context.read<DeleteBlogBloc>().add(
                                                        DeleteBlog(
                                                          bid: snapshot.child('bid').value.toString(),
                                                        ),
                                                      );
                                                },
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
