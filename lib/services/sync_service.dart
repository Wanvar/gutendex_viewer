
import 'package:gutendex_viewer/services/book_api_service.dart';
import 'package:gutendex_viewer/services/local_database_service.dart';

import '../models/book.dart';
import '../designes/book_filter.dart';

class SyncService {

  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();


  final BookApiService _apiService = BookApiService();

  bool get hasNext => _apiService.hasNext;
  bool get hasPrev => _apiService.hasPrev;




  void updateFilter(BookFilter filter) {

    _apiService.setNewQuery(filter:  filter);


  }

  Future<List<Book>> fetchPage({int? page, int offset = 0}) async {

    _apiService.setPage(page_num: page, offset: offset);
    String key = _apiService.uriKey();
    var res = LocalDatabaseService.getCachedPage(key);
    if(res != null)
      return res;

    var apiRes = await _apiService.fetchPage();
    LocalDatabaseService.savePageMapping(key, apiRes);

    return apiRes;





  }



}