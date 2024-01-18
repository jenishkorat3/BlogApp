import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jkblog/blocs/delete_blog_bloc/delete_blog_bloc.dart';
import 'package:jkblog/screens/full_image_screen.dart';
import 'package:shimmer/shimmer.dart';

Widget blogsCard(context, DataSnapshot snapshot, String uEmail, String caller) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  child: Text(
                    uEmail.contains("@") ? "By: ${uEmail.substring(0, uEmail.indexOf("@"))}" : "",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              caller == "profile_screen"
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
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
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget shimmerblogsCard(context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[500]!,
    highlightColor: Colors.grey[200]!,
    child: Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.4,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.29,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
