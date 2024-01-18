// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FullImageScreen extends StatelessWidget {
  final String blogImageUrl;
  const FullImageScreen({
    Key? key,
    required this.blogImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Blog Image'),
      ),
      body: Expanded(
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
    );
  }
}
