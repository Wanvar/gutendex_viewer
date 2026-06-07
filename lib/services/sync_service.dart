import 'dart:developer';
import 'dart:math';

import 'package:gutendex_viewer/services/book_api_service2.dart';
import 'package:gutendex_viewer/services/local_database_service.dart';

import '../models/book.dart';
import '../models/book_info.dart';
import '../models/book_filter.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();

  factory SyncService() => _instance;

  SyncService._internal();

  final BookApiService2 _apiService = BookApiService2();

  int _currentPage = 1;
  static const int _maxItems = 30;
  int _allItems = 0;

  bool get hasNext => _currentPage * _maxItems < _allItems;

  bool get hasPrev => _currentPage > 1;

  BookFilter? curFilter;

  void updateFilter(BookFilter filter) {
    curFilter = filter;
  }

  bool isFirstCall = true;

  Future<void> ensureDB() async {
    if (!isFirstCall) return;
    isFirstCall = false;

    try {

      var booksData = await _apiService.fetchAllBooks().timeout(
        const Duration(seconds: 10),
      );


      await LocalDatabaseService.saveBookInfos(booksData);

    } catch (e) {


      if (LocalDatabaseService.isEmpty) {
        throw Exception(
          "Brak połączenia z internetem i brak danych lokalnych.",
        );
      }
    }
  }

  List<BookInfo> getFiltered(List<BookInfo> allInfos) {
    final query = curFilter!.search;
    final selectedEpoch = curFilter!.epoch;
    final selectedGenre = curFilter!.genre;
    final selectedKind = curFilter!.kind;

    final filtered = allInfos.where((book) {
      final matchesSearch =
          query.isEmpty ||
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);

      final matchesEpoch = selectedEpoch == null || book.epoch == selectedEpoch;
      final matchesGenre = selectedGenre == null || book.genre == selectedGenre;
      final matchesKind = selectedKind == null || book.kind == selectedKind;

      return matchesSearch && matchesEpoch && matchesGenre && matchesKind;
    }).toList();

    return filtered;
  }

  Future<List<BookInfo>> fetchPage({int? page, int offset = 0}) async {
    await ensureDB();

    List<BookInfo> allInfos = LocalDatabaseService.getBookInfos();
    List<BookInfo> filtered = getFiltered(allInfos);

    _allItems = filtered.length;
    //log("len: ${filtered.length}", name: "sync");
    int p = page ?? _currentPage;
    p += offset;
    _currentPage = p;

    int idxStart = (p - 1) * _maxItems;
    int idxEnd = idxStart + _maxItems;

    idxEnd = min(idxEnd, _allItems);

    // var res = LocalDatabaseService.getCachedPage(key);
    // if (res != null) return res;

    //var apiRes = await _apiService.fetchPage();
    //LocalDatabaseService.savePageMapping(key, apiRes);

    return filtered.sublist(idxStart, idxEnd);
  }
}
