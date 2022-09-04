import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
 
  Future<http.Response> authenticate(String email, String password, String urlFragment) async {
  final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyDaFvZJdYeGtdHXlVDjkMwD8WTD7PQ6sYY';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    return response;
  }
}