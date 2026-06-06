import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../designes/book_filter.dart';




class BookApiService {

  static final BookApiService _instance = BookApiService._internal();
  factory BookApiService() => _instance;
  BookApiService._internal();

  BookFilter? _filter;

  Uri? _baseUrl;

  int _currentPage = 1;
  int _allItems = 1;

  final int _limit = 32;

String uriKey() => createUrl(_filter!.search, _filter!.language,
    _filter!.subject, _currentPage, _limit).toString();

  // Te getery idealnie współpracują z Twoim PaginationNavBar
  bool get hasNext => _currentPage * _limit < _allItems ;
  bool get hasPrev => _currentPage > 1;

  Uri createUrl(String search, String? language, String? subject, int page, int limit ) {
    return Uri.https(
      "openlibrary.org",
      "/search.json",
      {
        "q": search,
        "page": "${page}",
        "limit": "${limit}",
        if (language != null) "language": language,
        if (subject != null) "subject": subject,
      },
    );
  }



  /// Wywoływane w widoku przy zmianie filtrów
  void setNewQuery({required BookFilter filter}) {
    _currentPage = 0;
    _filter = filter;

  }

  void setPage({int? page_num, int offset = 0}){
    int target_page = page_num ?? _currentPage;
    _currentPage = target_page + offset;
  }


  Future<List<Book>> fetchPage() async {




    final url = createUrl(_filter!.search, _filter!.language,
        _filter!.subject, _currentPage, _limit);

    final response = await http.get(url).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final data = await compute(jsonDecode, response.body);



      _allItems  = data["numFound"] ?? 0;
      final List docs = data["docs"] ?? [];

    log("items: $_allItems");
    log("has_next: $hasNext" );


      return docs.map((doc) {

        final List<String> authorNames = List<String>.from(doc["author_name"] ?? []);
        final List<Map<String, String>> formattedAuthors = authorNames
            .map((name) => {"name": name})
            .toList();


        final List<String> languages = List<String>.from(doc["language"] ?? []);


        final Map<String, dynamic> res = {
          "id": doc["cover_i"] ?? 0,
          "title": doc["title"] ?? "Brak tytułu",
          "authors": formattedAuthors,
          "languages": languages,
          "formats": {
            "image/jpeg": doc["cover_i"] != null
                ? "https://covers.openlibrary.org/b/id/${doc["cover_i"]}-M.jpg"
                : ""
          }
        };

        return Book.fromMap(res);
      }).toList();
    } else {
      throw Exception("Błąd Open Library: ${response.statusCode}");
    }
  }
}