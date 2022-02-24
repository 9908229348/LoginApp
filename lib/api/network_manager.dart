import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NetworkManager {
  static Future<http.Response> registration(
      String email, String firstName, String lastName, String password) async {
    String endPointUrl = "http://10.0.2.2:8080/api/auth/registration";

    Response response = await http.post(
      Uri.parse(endPointUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
      },
      body: jsonEncode(<String, String>{
        "email": "teja@gmail.com",
        "firstName": "teja",
        "lastName": "teja",
        "password": "teja"
      }),
    );
    return response;
  }

  Future<http.Response> logIn(String email, String password) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/auth/authenticate'),
    );
    return response;
  }
}
