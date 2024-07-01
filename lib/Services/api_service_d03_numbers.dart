import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/d03_numbers.dart';

class ApiService {
  // final String baseUrl = 'https://localhost:44397/api/D03number';
  final String baseUrl = 'http://10.89.5.183:155/api/D03number';

  Future<D03numbers> fetchFirst() async {
    final response = await http.get(Uri.parse('$baseUrl/first'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return D03numbers.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load first record');
    }
  }

  Future<D03numbers> fetchLast() async {
    final response = await http.get(Uri.parse('$baseUrl/last'));
    if (response.statusCode == 200) {
      return D03numbers.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load last record');
    }
  }

  Future<D03numbers> fetchNext(int currentID) async {
    final response = await http.get(Uri.parse('$baseUrl/next/$currentID'));
    if (response.statusCode == 200) {
      return D03numbers.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load next record');
    }
  }

  Future<D03numbers> fetchPrevious(int currentID) async {
    final response = await http.get(Uri.parse('$baseUrl/previous/$currentID'));
    if (response.statusCode == 200) {
      return D03numbers.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load previous record');
    }
  }

  Future<List<D03numbers>> search(String searchTerm) async {
    final response = await http.get(Uri.parse('$baseUrl/search/$searchTerm'));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((e) => D03numbers.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search records');
    }
  }
  Future<void> createOrUpdate(D03numbers d03numbers) async {
    final jsonData = json.encode(d03numbers.toJson());
    final response = await http.post(
      Uri.parse('$baseUrl/createOrUpdate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create or update record');
    }
  }
  Future<void> create(D03numbers d03numbers) async {
    final jsonData = json.encode(d03numbers.toJson());
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
        throw Exception('ID already exists. Please create a unique ID.');
      } else {
        throw Exception('Failed to create record');
      }
    }
  }

  Future<void> update(int id, D03numbers d03numbers) async {
    final jsonData = json.encode(d03numbers.toJson());
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update record');
    }
  }
}
