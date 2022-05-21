import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class CSVHandler {
  static Map<String, List<List<dynamic>>?> storage = {};

  static Future<List<List<dynamic>>> readCsvFile(filepath) async {
    if (storage[filepath] != null) {
      return storage[filepath]!;
    }

    final data = await rootBundle.loadString(filepath);
    final fields = const CsvToListConverter().convert(data);
    storage[filepath] = fields;

    return fields;
  }

  static List<dynamic>? getByFieldValue(
      int columnID, dynamic value, String filepath) {
    for (List<dynamic> list in storage[filepath] ?? []) {
      if (list[columnID] == value) {
        return list;
      }
    }
    return null;
  }
}
