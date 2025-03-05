import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double height;

  const Logo({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset('assets/images/logo.png', height: height, fit: BoxFit.cover));
  }
}
