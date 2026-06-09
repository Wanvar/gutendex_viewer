import 'dart:developer';
import 'dart:math' as math;
import 'package:gutendex_viewer/services/book_api_service2.dart';
import 'package:gutendex_viewer/services/local_database_service.dart';
import '../models/book_info.dart';
import '../models/book_details.dart';
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

  int get currentPage => _currentPage;
  int get maxPage => math.max((_allItems/ _maxItems).ceil(), 1);
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


      await LocalDatabaseService.saveBookInfos(booksData, false);

    } catch (e) {


      if (LocalDatabaseService.isEmpty) {
        throw Exception(
          "Brak połączenia z internetem i brak danych lokalnych.",
        );
      }
    }
  }

  BookInfo? getBookInfo(String key)  {
    return LocalDatabaseService.getBookInfo(key);
  }

  Future<void> toggleMarkBook(String key) async{
    await LocalDatabaseService.toggleMarkBook(key);
  }

  Future<BookDetails> fetchBookDetails(String slug) async {


    var result = LocalDatabaseService.getBookDetails(slug);
    if( result != null) return result;


    log("ładowanie detali z api", name: "sync");
    BookDetails apiResult = await _apiService.fetchBookDetails(slug);
    LocalDatabaseService.saveBookDetails(slug, apiResult);
    return apiResult;


  }


  List<BookInfo> getFiltered(List<BookInfo> allInfos) {
    final query = curFilter!.search.toLowerCase();
    final selectedEpoch = curFilter!.epoch;
    final selectedGenre = curFilter!.genre;
    final selectedKind = curFilter!.kind;
    final selectedOnlyMarked = curFilter!.showOnlyMarked;

    final filtered = allInfos.where((book) {
      final matchesSearch =
          query.isEmpty ||
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);

      final matchesEpoch = selectedEpoch == null || book.epoch == selectedEpoch;
      final matchesGenre = selectedGenre == null || book.genre == selectedGenre;
      final matchesKind = selectedKind == null || book.kind == selectedKind;
      final matchesMarked = selectedOnlyMarked  == false || book.isMarked == true;

      return matchesSearch && matchesEpoch && matchesGenre && matchesKind && matchesMarked;
    }).toList();

    return filtered;
  }

  Future<List<BookInfo>> fetchPage({int? page, int offset = 0}) async {
    await ensureDB();

    List<BookInfo> allInfos = LocalDatabaseService.getBookInfos();
    List<BookInfo> filtered = getFiltered(allInfos);

    _allItems = filtered.length;

    int p = page ?? _currentPage;
    p += offset;
    _currentPage = p;

    int idxStart = (p - 1) * _maxItems;
    int idxEnd = idxStart + _maxItems;

    idxEnd = math.min(idxEnd, _allItems);


    return filtered.sublist(idxStart, idxEnd);
  }
}
