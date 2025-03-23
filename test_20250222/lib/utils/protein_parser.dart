import 'dart:io';
import 'package:xml/xml.dart' as xml;

class ProteinParser {
  static Future<List<String>> parseProteins(String filePath) async {
    try {
      final file = File(filePath);
      final xmlString = await file.readAsString();
      final document = xml.XmlDocument.parse(xmlString);

      final proteins = document.findAllElements('dict').map((dict) {
        final proteinElement = dict.findElements('key').firstWhere(
          (key) => key.text == 'Protein',
          orElse: () => xml.XmlElement(xml.XmlName('')),
        );
        return proteinElement.nextElementSibling?.text;
      }).whereType<String>().toList();

      return proteins;
    } catch (e) {
      print('Error parsing proteins: $e');
      return [];
    }
  }
}
