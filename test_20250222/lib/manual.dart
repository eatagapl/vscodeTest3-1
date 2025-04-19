import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ManualScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Manual'),
      ),
      body: SfPdfViewer.asset(
        'assets/manual.pdf', // Path to your PDF file in the assets folder
      ),
    );
  }
}