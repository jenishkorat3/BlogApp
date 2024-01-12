// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool showSpinner;
  const RoundButton({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.showSpinner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showSpinner == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        color: Colors.deepOrange,
        minWidth: double.infinity,
        height: 50,
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
