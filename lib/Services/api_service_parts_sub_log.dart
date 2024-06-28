import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/parts_sub_log.dart';

class ApiService {
  final String baseUrl = 'https://localhost:44397/api/SubLog';

  Future<PartSubLog> fetchFirstLog() async {
    final response = await http.get(Uri.parse('$baseUrl/first'));

    if (response.statusCode == 200) {
      return PartSubLog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load first log');
    }
  }

  Future<PartSubLog> fetchLastLog() async {
    final response = await http.get(Uri.parse('$baseUrl/last'));
    if (response.statusCode == 200) {
      return PartSubLog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load last log');
    }
  }

  Future<PartSubLog> fetchNextLog(String currentNO) async {
    final response = await http.get(Uri.parse('$baseUrl/next/$currentNO'));
    if (response.statusCode == 200) {
      return PartSubLog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load next log');
    }
  }

  Future<PartSubLog> fetchPreviousLog(String currentNO) async {
    final response = await http.get(Uri.parse('$baseUrl/previous/$currentNO'));
    if (response.statusCode == 200) {
      return PartSubLog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load previous log');
    }
  }

  Future<List<PartSubLog>> searchLog(String searchTerm) async {
    final response = await http.get(Uri.parse('$baseUrl/search/$searchTerm'));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((e) => PartSubLog.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search log');
    }
  }

  Future<void> createLog(PartSubLog partSubLog) async {
    final jsonData = json.encode(partSubLog.toJson());
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    if (response.statusCode != 200) {
      if (response.statusCode == 409) {
        throw Exception('NO already exists. Please create a unique NO.');
      } else {
        throw Exception('Failed to create log');
      }
    }
  }

  Future<void> updateLog(String no, PartSubLog partSubLog) async {
    final jsonData = json.encode(partSubLog.toJson());
    final response = await http.put(
      Uri.parse('$baseUrl/Update/$no'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update log');
    }
  }
}
