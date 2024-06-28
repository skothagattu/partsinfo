import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cab_aire_dwg_numbers.dart';

class ApiService {
  final String baseUrl = 'https://localhost:44397/api/CabAireDWGNumber';

  Future<CabAireDWGNumber> fetchFirst() async {
    final response = await http.get(Uri.parse('$baseUrl/first'));
    if (response.statusCode == 200) {
      return CabAireDWGNumber.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load first record');
    }
  }

  Future<CabAireDWGNumber> fetchLast() async {
    final response = await http.get(Uri.parse('$baseUrl/last'));
    if (response.statusCode == 200) {
      return CabAireDWGNumber.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load last record');
    }
  }

  Future<CabAireDWGNumber> fetchNext(int currentNo) async {
    final response = await http.get(Uri.parse('$baseUrl/next/$currentNo'));
    if (response.statusCode == 200) {
      return CabAireDWGNumber.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load next record');
    }
  }

  Future<CabAireDWGNumber> fetchPrevious(int currentNo) async {
    final response = await http.get(Uri.parse('$baseUrl/previous/$currentNo'));
    if (response.statusCode == 200) {
      return CabAireDWGNumber.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load previous record');
    }
  }

  Future<List<CabAireDWGNumber>> search(String searchTerm) async {
    final response = await http.get(Uri.parse('$baseUrl/search/$searchTerm'));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((e) => CabAireDWGNumber.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search records');
    }
  }

  Future<void> create(CabAireDWGNumber cabAireDWGNumber) async {
    final jsonData = json.encode(cabAireDWGNumber.toJson());
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

  Future<void> update(int no, CabAireDWGNumber cabAireDWGNumber) async {
    final jsonData = json.encode(cabAireDWGNumber.toJson());
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
