import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/three_letter_code.dart';

class ApiService {
  final String baseUrl = 'https://localhost:44397/api/ThreeLetterCode';

  Future<ThreeLetterCode> fetchFirstCode() async {
    final response = await http.get(Uri.parse('$baseUrl/firstcode')); // Updated endpoint
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

  Future<ThreeLetterCode> searchCode(String searchTerm) async {
    final response = await http.get(Uri.parse('$baseUrl/search/$searchTerm'));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      if (list.isNotEmpty) {
        return ThreeLetterCode.fromJson(list[0]);
      } else {
        throw Exception('No code found');
      }
    } else {
      throw Exception('Failed to search code');
    }
  }

  Future<void> createCode(ThreeLetterCode threeLetterCode) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(threeLetterCode.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create code');
    }
  }
}
