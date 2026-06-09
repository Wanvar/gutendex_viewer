import 'package:flutter/material.dart';
import 'package:gutendex_viewer/services/local_database_service.dart';
import '../views/book_list_view.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await LocalDatabaseService.init();
  //await LocalDatabaseService.clear();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Biblioteka Wolne Lektury", home: BookListView());
  }
}