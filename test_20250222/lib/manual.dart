import 'package:flutter/material.dart';

class ManualScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'User Manual',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'This manual provides instructions on how to use PopNeuron. '
                'Navigate through the app using the bottom navigation bar. '
                'Refer to the About section for more details.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}