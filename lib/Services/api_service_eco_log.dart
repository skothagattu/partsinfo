import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/eco_log.dart';

class ApiService {
  // final String baseUrl = 'https://localhost:44397/api/EcoLog';

  final String baseUrl = 'http://10.89.5.183:155/api/EcoLog';

  Future<EcoLog> fetchFirst() async {
    final response = await http.get(Uri.parse('$baseUrl/first'));
    if (response.statusCode == 200) {
      return EcoLog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load first record');
    }
  }

  Future<EcoLog> fetchLast() async {
    final response = await http.get(Uri.parse('$baseUrl/last'));
    if (response.statusCode == 200) {
      return EcoLog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load last record');
    }
  }

  Future<EcoLog> fetchNext(int currentNO) async {
    final response = await http.get(Uri.parse('$baseUrl/next/$currentNO'));
    if (response.statusCode == 200) {
      return EcoLog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load next record');
    }
  }

  Future<EcoLog> fetchPrevious(int currentNO) async {
    final response = await http.get(Uri.parse('$baseUrl/previous/$currentNO'));
    if (response.statusCode == 200) {
      return EcoLog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load previous record');
    }
  }

  Future<List<EcoLog>> search(String searchTerm) async {
    final response = await http.get(Uri.parse('$baseUrl/search/$searchTerm'));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((e) => EcoLog.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search records');
    }
  }

  Future<void> createOrUpdate(EcoLog ecoLog) async {
    final jsonData = json.encode(ecoLog.toJson());
    final response = await http.post(
      Uri.parse('$baseUrl/createOrUpdate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create or update record');
    }
  }

  Future<void> create(EcoLog ecoLog) async {
    final jsonData = json.encode(ecoLog.toJson());
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    if (response.statusCode != 200) {
      if (response.statusCode == 409) {
        throw Exception('NO already exists. Please create a unique NO.');
      } else {
        throw Exception('Failed to create record');
      }
    }
  }

  Future<void> update(int no, EcoLog ecoLog) async {
    final jsonData = json.encode(ecoLog.toJson());
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
