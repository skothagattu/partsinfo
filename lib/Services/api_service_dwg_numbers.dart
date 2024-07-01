import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dwg_numbers.dart';

class ApiServiceDWGNumbers {
  // final String baseUrl = 'https://localhost:44397/api/DWGnumber';

  final String baseUrl = 'http://10.89.5.183:155/api/DWGnumber';

  Future<DWGNumbers> fetchFirst() async {
    final response = await http.get(Uri.parse('$baseUrl/first'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return DWGNumbers.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load first record');
    }
  }

  Future<DWGNumbers> fetchLast() async {
    final response = await http.get(Uri.parse('$baseUrl/last'));
    if (response.statusCode == 200) {
      return DWGNumbers.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load last record');
    }
  }

  Future<DWGNumbers> fetchNext(int currentNO) async {
    final response = await http.get(Uri.parse('$baseUrl/next/$currentNO'));
    if (response.statusCode == 200) {
      return DWGNumbers.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load next record');
    }
  }

  Future<DWGNumbers> fetchPrevious(int currentNO) async {
    final response = await http.get(Uri.parse('$baseUrl/previous/$currentNO'));
    if (response.statusCode == 200) {
      return DWGNumbers.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load previous record');
    }
  }

  Future<List<DWGNumbers>> search(String searchTerm) async {
    final response = await http.get(Uri.parse('$baseUrl/search/$searchTerm'));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((e) => DWGNumbers.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search records');
    }
  }
  Future<void> createOrUpdate(DWGNumbers dwgNumbers) async {
    final jsonData = json.encode(dwgNumbers.toJson());
    final response = await http.post(
      Uri.parse('$baseUrl/createOrUpdate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create or update record');
    }
  }

  Future<void> create(DWGNumbers dwgNumbers) async {
    final jsonData = json.encode(dwgNumbers.toJson());
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
        throw Exception('NO already exists. Please create a unique NO.');
      } else {
        throw Exception('Failed to create record');
      }
    }
  }

  Future<void> update(int no, DWGNumbers dwgNumbers) async {
    final jsonData = json.encode(dwgNumbers.toJson());
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
