import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class Api {
 
   static Future<List<Map<String, dynamic>>> getInfo() async {
    final response = await http.get(Uri.parse("http://192.168.31.174:8000/api/v1/user"));
    if (response.statusCode == 200) {
      // Successful response
      final List<dynamic> responseData = jsonDecode(response.body);
      List<Map<String, dynamic>> userlist =
          responseData.cast<Map<String, dynamic>>();
      return userlist;
    } else {
      // Handle HTTP error
      print('HTTP Error: ${response.statusCode}');
      return [];
    }
  }

   static Future<List<Map<String, dynamic>>> getInfo1() async {
    final response = await http.get(Uri.parse("http://192.168.31.174:8000/api/v1/test"));
    if (response.statusCode == 200) {
      // Successful response
      final List<dynamic> responseData = jsonDecode(response.body);
      List<Map<String, dynamic>> userlist =
          responseData.cast<Map<String, dynamic>>();
      return userlist;
    } else {
      // Handle HTTP error
      print('HTTP Error: ${response.statusCode}');
      return [];
    }
  }

  

}
