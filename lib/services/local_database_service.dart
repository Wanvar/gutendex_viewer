
import 'package:gutendex_viewer/models/book_details.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/book_info.dart';

class LocalDatabaseService {


  static const String _bookInfos = 'infos';
  static const String _bookDetails = 'details';


  static const String _markedBoxName = 'marked_books';


  static bool get isEmpty =>
      Hive
          .box<Map>(_bookInfos)
          .isEmpty;

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_bookInfos);
    await Hive.openBox<List>(_markedBoxName);
    await Hive.openBox<Map>(_bookDetails);
  }

  static Future<void> saveBookDetails(String key, BookDetails details) async {
    final box = Hive.box<Map>(_bookDetails);

    await box.put(key, details.toMap());
  }

  static BookDetails? getBookDetails(String key) {
    final box = Hive.box<Map>(_bookDetails);

    final raw = box.get(key);

    if (raw == null) return null;

    return BookDetails.fromMap(
      Map<String, dynamic>.from(raw),
    );
  }

  static Future<void> clear() async {
    await Hive.box<Map>(_bookInfos).clear();
    await Hive.box<Map>(_bookDetails).clear();
  }

  static Future<void> saveBookInfos(List<BookInfo> infos, bool force) async {
    final box = Hive.box<Map>(_bookInfos);
    if(force)
      await box.clear();

    for (var info in infos) {
      if(!box.containsKey(info.slug))
        await box.put(info.slug, info.toMap());
    }
  }

  static List<BookInfo> getBookInfos() {
    final box = Hive.box<Map>(_bookInfos);
    return box.values.map((item) {
      return BookInfo.fromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  static BookInfo? getBookInfo(String key) {
    final box = Hive.box<Map>(_bookInfos);

    final raw = box.get(key);

    if (raw == null) return null;

    return BookInfo.fromMap(
      Map<String, dynamic>.from(raw),
    );
  }


  static Future<void> toggleMarkBook(String key) async {
    final box = Hive.box<Map>(_bookInfos);

    final BookInfo info = BookInfo.fromMap(
        Map<String, dynamic>.from(box.get(key)!));

    await box.put(key, info.copyWith(isMarked: !info.isMarked).toMap());
  }

}