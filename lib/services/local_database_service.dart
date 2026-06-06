
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../models/book.dart';

class LocalDatabaseService {



  static const String _booksBoxName = 'books';
  static const String _pagesBoxName = 'cached_pages';
  static const String _markedBoxName = 'marked_books';


  static const String _favKey = 'favorites_list';


  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_booksBoxName);       // Przechowuje surowe mapy książek: int -> Map
    await Hive.openBox<List>(_pagesBoxName);      // Przechowuje listy ID dla stron: String -> List<int>
    await Hive.openBox<List>(_markedBoxName);     // Przechowuje listę ulubionych: String -> List<int>
  }


  static Future<void> saveBooks(List<Book> books) async {
    final box = Hive.box<Map>(_booksBoxName);
    for (var book in books) {

      box.put(book.id, book.toMap());
    }
  }


  static List<Book> getBooksByIds(List<int> ids) {
    final box = Hive.box<Map>(_booksBoxName);
    final List<Book> books = [];

    for (var id in ids) {
      final cachedMap = box.get(id);
      if (cachedMap != null) {

        final Map<String, dynamic> strictMap = Map<String, dynamic>.from(cachedMap);
        books.add(Book.fromMap(strictMap));
      }
    }
    return books;
  }


  static Future<void> savePageMapping(String key,  List<Book> booksOnPage) async {
    final box = Hive.box<List>(_pagesBoxName);



    final List<int> bookIds = booksOnPage.map((b) => b.id).toList();

    await box.put(key, bookIds);

    await saveBooks(booksOnPage);
  }


  static List<Book>? getCachedPage(String uriKey) {
    final box = Hive.box<List>(_pagesBoxName);
    final String key = uriKey.toLowerCase();

    final List? bookIds = box.get(key);
    if (bookIds == null) return null;


    return getBooksByIds(List<int>.from(bookIds));
  }



  static List<int> getMarkedBookIds() {
    final box = Hive.box<List>(_markedBoxName);
    final List? list = box.get(_favKey);
    return list != null ? List<int>.from(list) : [];
  }


  static Future<void> toggleMarkBook(int bookId) async {
    final box = Hive.box<List>(_markedBoxName);
    final List<int> currentMarked = getMarkedBookIds();

    if (currentMarked.contains(bookId)) {
      currentMarked.remove(bookId);
    } else {
      currentMarked.add(bookId);
    }

    await box.put(_favKey, currentMarked);
  }


  static bool isBookMarked(int bookId) {
    return getMarkedBookIds().contains(bookId);
  }
}