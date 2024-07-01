import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ecr_log.dart';

class ApiServiceEcrLog {
  // final String baseUrl = 'https://localhost:44397/api/EcrLog';
  final String baseUrl = 'http://10.89.5.183:155/api/EcrLog';

  Future<EcrLog> fetchFirst() async {
    final response = await http.get(Uri.parse('$baseUrl/first'));
    if (response.statusCode == 200) {
      return EcrLog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load first record');
    }
  }

  Future<EcrLog> fetchLast() async {
    final response = await http.get(Uri.parse('$baseUrl/last'));
    if (response.statusCode == 200) {
      return EcrLog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load last record');
    }
  }

  Future<EcrLog> fetchNext(int currentNO) async {
    final response = await http.get(Uri.parse('$baseUrl/next/$currentNO'));
    if (response.statusCode == 200) {
      return EcrLog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load next record');
    }
  }

  Future<EcrLog> fetchPrevious(int currentNO) async {
    final response = await http.get(Uri.parse('$baseUrl/previous/$currentNO'));
    if (response.statusCode == 200) {
      return EcrLog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load previous record');
    }
  }

  Future<List<EcrLog>> search(String searchTerm) async {
    final response = await http.get(Uri.parse('$baseUrl/search/$searchTerm'));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((e) => EcrLog.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search records');
    }
  }

  Future<void> createOrUpdate(EcrLog ecrLog) async {
    final jsonData = json.encode(ecrLog.toJson());
    final response = await http.post(
      Uri.parse('$baseUrl/createOrUpdate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create or update record');
    }
  }

  Future<void> update(int no, EcrLog ecrLog) async {
    final jsonData = json.encode(ecrLog.toJson());
    final response = await http.put(
      Uri.parse('$baseUrl/update/$no'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update record');
    }
  }
}
