import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../views/book_list_view.dart';


void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Hive.initFlutter(); // inicjalizacja

  //await Hive.openBox("tasks"); // otwarcie kontenera
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "demo", home: BookListView());
  }
}