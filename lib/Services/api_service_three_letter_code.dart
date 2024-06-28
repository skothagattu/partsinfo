import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/three_letter_code.dart';

class ApiService {
  final String baseUrl = 'https://localhost:44397/api/ThreeLetterCode';

  Future<ThreeLetterCode> fetchFirstCode() async {
    final response = await http.get(Uri.parse('$baseUrl/firstcode')); // Updated endpoint
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return ThreeLetterCode.fromJson(json.decode(response.body));

    }
    else {
      throw Exception('Failed to load first code');
    }
  }

  Future<ThreeLetterCode> fetchLastCode() async {
    final response = await http.get(Uri.parse('$baseUrl/last')); // Updated endpoint
    if (response.statusCode == 200) {
      return ThreeLetterCode.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load first code');
    }
  }

  Future<ThreeLetterCode> fetchNextCode(String currentCode) async {
    final response = await http.get(Uri.parse('$baseUrl/next/$currentCode'));
    if (response.statusCode == 200) {
      return ThreeLetterCode.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load next code');
    }
  }

  Future<ThreeLetterCode> fetchPreviousCode(String currentCode) async {
    final response = await http.get(Uri.parse('$baseUrl/previous/$currentCode'));
    if (response.statusCode == 200) {
      return ThreeLetterCode.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load previous code');
    }
  }


  Future<List<ThreeLetterCode>> searchCode(String searchTerm) async {
    final response = await http.get(Uri.parse('$baseUrl/search/$searchTerm'));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((e) => ThreeLetterCode.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search code');
    }
  }

  Future<void> createCode(ThreeLetterCode threeLetterCode) async {
    final jsonData = json.encode(threeLetterCode.toJson());
    print('Sending JSON data: $jsonData');
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode != 200) {
      if (response.statusCode == 409) {
        throw Exception('Code already exists. Please create a unique code.');
      } else {
        throw Exception('Failed to create code');
      }
    }
  }
  Future<void> updateCode(String code, ThreeLetterCode threeLetterCode) async {
    final jsonData = json.encode(threeLetterCode.toJson());
    final response = await http.put(
      Uri.parse('$baseUrl/Update/$code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update code');
    }
  }
}
