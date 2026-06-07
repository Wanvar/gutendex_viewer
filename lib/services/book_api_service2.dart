import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_info.dart';
import '../models/book_details.dart';
import '../designes/book_filter.dart';



class BookApiService2 {
  static const String _baseUrl = 'https://wolnelektury.pl/api';



  Future<List<BookInfo>> fetchAllBooks() async {
    final url = Uri.parse('$_baseUrl/books/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {

        final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));


        return jsonList.map((json) => BookInfo.fromMap(json)).toList();
      } else {
        throw Exception('Nie udało się pobrać listy książek. Kod błędu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Błąd sieciowy podczas pobierania katalogu: $e');
    }
  }


  Future<BookDetails> fetchBookDetails(String slug) async {
    final url = Uri.parse('$_baseUrl/books/$slug/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {

        final Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(response.bodyBytes));


        return BookDetails.fromMap(jsonMap);
      } else {
        throw Exception('Nie udało się pobrać szczegółów książki "$slug". Kod błędu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Błąd sieciowy podczas pobierania szczegółów dla $slug: $e');
    }
  }
}