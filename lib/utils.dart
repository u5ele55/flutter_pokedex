import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<List<dynamic>>> readCsvFile(filepath) async {
  final data = await rootBundle.loadString(filepath);
  final fields = CsvToListConverter().convert(data);

  return fields;
}

Future<List<List<dynamic>>> filterByUniqueId(
    Future<List<List<dynamic>>> fields) async {
  List<List<dynamic>> filtered = [];
  List<List<dynamic>> readyFields = await fields;
  for (int i = 0; i < readyFields.length - 1; i++) {
    if (readyFields[i + 1][0] != readyFields[i][0])
      filtered.add(readyFields[i + 1]);
  }
  return filtered;
}
