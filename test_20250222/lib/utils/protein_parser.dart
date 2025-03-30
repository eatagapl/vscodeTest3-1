import 'dart:io';
import 'dart:convert';
import 'package:xml/xml.dart' as xml;

class ProteinParser {
  static const String _filePath = 'C:/Users/antho/OneDrive/Desktop/flutter/OptogeneticsFlutter/vscodeTest3-1/test_20250222/xmlfiles/ProteinsThresholds.xml'; // Updated to relative path

  static Future<List<Map<String, String>>> parseProteins() async {
    try {
      final file = File(_filePath);
      if (!await file.exists()) {
        print('Error: File not found at $_filePath');
        return [];
      }

      final xmlString = await file.readAsString();
      final document = xml.XmlDocument.parse(xmlString);

      final proteins = document.findAllElements('dict').map((dict) {
        final proteinData = <String, String>{};
        for (final element in dict.children.whereType<xml.XmlElement>()) {
          if (element.name.local == 'key') {
            final key = element.text;
            final valueElement = element.nextElementSibling;
            if (valueElement != null) {
              proteinData[key] = valueElement.text;
            }
          }
        }
        return proteinData;
      }).toList();

      print('Parsed Proteins: $proteins'); // Debug: Print the parsed proteins
      return proteins;
    } catch (e) {
      print('Error parsing proteins: $e');
      return [];
    }
  }

  static List<Map<String, String>> parseProteinsThresholds(String xmlFilePath) {
    final file = File(xmlFilePath);
    final document = xml.XmlDocument.parse(file.readAsStringSync());
    final proteinsArray = <Map<String, String>>[];

    final dictElements = document.findAllElements('dict');
    for (var dict in dictElements) {
      final proteinData = <String, String>{};
      final children = dict.children.where((node) => node is xml.XmlElement).toList();

      for (var i = 0; i < children.length; i += 2) {
        final key = children[i].innerText;
        final value = children[i + 1].innerText;
        proteinData[key] = value;
      }
      proteinsArray.add(proteinData);
    }

    return proteinsArray;
  }
}
