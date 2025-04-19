import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  // Function to launch a URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 8.0, // Space between columns
        mainAxisSpacing: 8.0, // Space between rows
        padding: const EdgeInsets.all(8.0),
        children: [
          // Button 1
          GestureDetector(
            onTap: () => _launchURL('https://example.com/1'),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[300],
                image: const DecorationImage(
                  image: AssetImage('assets/image1.png'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Button 2
          GestureDetector(
            onTap: () => _launchURL('https://example.com/2'),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[300],
                image: const DecorationImage(
                  image: AssetImage('assets/image2.png'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Button 3
          GestureDetector(
            onTap: () => _launchURL('https://example.com/3'),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[300],
                image: const DecorationImage(
                  image: AssetImage('assets/image3.png'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Button 4
          GestureDetector(
            onTap: () => _launchURL('https://example.com/4'),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[300],
                image: const DecorationImage(
                  image: AssetImage('assets/image4.png'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}