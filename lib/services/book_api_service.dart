import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookApiService {
  static const String baseUrl = "https://gutendex.com";


  static Future<List<Book>> fetchBooks({String? lang}) async {

    String url = "$baseUrl/books/";
    if (lang != null && lang != "all") {
      url += "?languages=$lang";
    }


    final response = await http.get(Uri.parse(url));


    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      final List results = data["results"];


      var out = results.map((bookJson) {


        return  Book.fromMap(Map<String, dynamic>.from(bookJson));
      }).toList();

      log("pobrane ksiażki: ${out.length}", name: "book_api_service");
      return out;
    } else {

      throw Exception("Błąd pobierania danych z API. Status: ${response.statusCode}");
    }
  }
}