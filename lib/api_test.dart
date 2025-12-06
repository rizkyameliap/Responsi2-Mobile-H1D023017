import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiTest {
  static Future<void> testAPI() async {
    final url = Uri.parse("http://localhost:8080/api/inventaris");

    try {
      final res = await http.get(url);

      print("STATUS CODE: ${res.statusCode}");
      print("BODY: ${res.body}");
    } catch (e) {
      print("ERROR: $e");
    }
  }
}
