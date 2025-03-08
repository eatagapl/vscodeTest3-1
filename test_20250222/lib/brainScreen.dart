import 'package:flutter/material.dart';

class BrainScreen extends StatelessWidget {
  final String selectedImage;

  const BrainScreen({required this.selectedImage});

  @override
  Widget build(BuildContext context) {
    String imagePath;
    switch (selectedImage) {
      case 'B':
        imagePath = 'assets/orange.jpg';
        break;
      case 'C':
        imagePath = 'assets/pear.png';
        break;
      case 'A':
      default:
        imagePath = 'assets/apple.jpg';
        break;
    }

    return Center(
      child: Image.asset(imagePath),
    );
  }
}