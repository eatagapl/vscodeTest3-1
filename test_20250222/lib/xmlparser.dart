import 'package:flutter/services.dart'; // For rootBundle
import 'package:xml/xml.dart';
import 'globalVariables.dart';

class XMLParser {
  static Future<List<Map<String, String>>?> parseProteinsThresholds() async {
    try {
      // Load the XML file from xmlfiles/ folder using rootBundle
      final xmlString = await rootBundle.loadString('xmlfiles/ProteinsThresholds.xml');
      
      // Parse the XML string
      final document = XmlDocument.parse(xmlString);
      final rootElement = document.rootElement;

      // Extract only the required data structure
      final List<Map<String, String>> entries = [];
      for (final dictElement in rootElement.findAllElements('dict')) {
        final Map<String, String> entry = {};
        final keyElements = dictElement.findElements('key');
        final valueElements = dictElement.findElements('string');

        for (int i = 0; i < keyElements.length; i++) {
          final key = keyElements.elementAt(i).text;
          final value = valueElements.elementAt(i).text;
          entry[key] = value;
        }
        entries.add(entry);
      }

      return entries;
    } catch (e) {
      print('Error parsing XML file: $e');
      return null;
    }
  }
}

// Global data structure to store protein data

Future<void> populateProteinData() async {
  try {
    // Load the XML file from xmlfiles/ folder using rootBundle
    final xmlString = await rootBundle.loadString('xmlfiles/ProteinsThresholds.xml');
    
    // Parse the XML string
    final document = XmlDocument.parse(xmlString);
    final rootElement = document.rootElement;

    // Populate the global proteinData structure
    for (final dictElement in rootElement.findAllElements('dict')) {
      String? proteinName;
      final Map<String, String> thresholds = {};

      final keyElements = dictElement.findElements('key');
      final valueElements = dictElement.findElements('string');

      for (int i = 0; i < keyElements.length; i++) {
        final key = keyElements.elementAt(i).text;
        final value = valueElements.elementAt(i).text;

        if (key == 'Protein') {
          proteinName = value;
        } else {
          thresholds[key] = value;
        }
      }

      if (proteinName != null) {
        proteinData[proteinName] = thresholds;
      }
    }

    // Print the entire proteinData dictionary
    //print(proteinData);
  } catch (e) {
    print('Error populating protein data: $e');
  }
}
