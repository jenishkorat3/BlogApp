// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FullImageScreen extends StatelessWidget {
  final String blogImageUrl;
  final String caller;
  const FullImageScreen({
    Key? key,
    required this.blogImageUrl,
    required this.caller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Blog Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: CachedNetworkImage(
                imageUrl: blogImageUrl,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[500]!,
                  highlightColor: Colors.grey[200]!,
                  child: Container(
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
          caller == "profile_screen"
              ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.deepOrange, Color.fromARGB(255, 246, 158, 132)], // Define your gradient colors
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8.0), // Match the button's shape
                    ),
                    height: 45,
                    width: 200,
                    alignment: Alignment.center,
                    child: const Text(
                      'Delete this blog',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                )
              : Center(),
        ],
      ),
    );
  }
}
