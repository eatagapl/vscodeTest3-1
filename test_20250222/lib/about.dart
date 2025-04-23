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
        title: const Text('About Our Other Projects'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _launchURL('https://popneuron.com/about/'), // Link to the about page
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 8.0, // Space between columns
        mainAxisSpacing: 8.0, // Space between rows
        padding: const EdgeInsets.all(8.0),
        childAspectRatio: 0.6, // Adjusted to make buttons longer rectangles
        children: [
          // Button 1
          GestureDetector(
            onTap: () => _launchURL('https://popneuron.com/project/popneuron-llc-wins-nih-small-business-grant-for-innovative-small-animal-stereotaxic-device/'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: AssetImage('assets/stereotaxi.png'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Small Animal Stereotaxic Device',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Button 2
          GestureDetector(
            onTap: () => _launchURL('https://popneuron.com/project/popneuron-llc-secures-nih-small-business-grant-to-revolutionize-neural-spike-sorting/'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: AssetImage('assets/spike sorting.png'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Neural Spike Sorting',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Button 3
          GestureDetector(
            onTap: () => _launchURL('https://popneuron.com/project/popneuron-is-developing-a-tabletop-hexapod/'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: AssetImage('assets/hexapod.png'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Tabletop Hexapod',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Button 4
          GestureDetector(
            onTap: () => _launchURL('https://popneuron.com/project/popneuron-developing-in-vitro-slice-and-recording-chamber/'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: AssetImage('assets/in vitro.png'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'In Vitro Slice and Recording Chamber',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}