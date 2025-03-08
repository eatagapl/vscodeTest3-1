import 'package:flutter/material.dart';

class BrainScreen extends StatelessWidget {
  final String selectedImage;

  const BrainScreen({required this.selectedImage});

  @override
  Widget build(BuildContext context) {
    String imagePath;
    switch (selectedImage) {
      case 'B':
        imagePath = 'assets/display/2dis.png';
        break;
      case 'C':
        imagePath = 'assets/display/3dis.png';
        break;
      case 'A':
      default:
        imagePath = 'assets/display/1dis.png';
        break;
    }

    return Center(
      child: Image.asset(imagePath),
    );
  }
}