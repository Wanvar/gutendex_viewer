import 'package:flutter/material.dart';
import '../models/book_filter.dart';


class BookFilterScreen extends StatefulWidget {
  const BookFilterScreen({super.key});

  @override
  State<BookFilterScreen> createState() => _BookFilterScreenState();
}

class _BookFilterScreenState extends State<BookFilterScreen> {
  final TextEditingController searchController = TextEditingController();


  final List<DropdownMenuItem<String?>> genreItems = const [
    DropdownMenuItem(value: null, child: Text("Dowolny gatunek")),
    DropdownMenuItem(value: "Powieść", child: Text("Powieść")),
    DropdownMenuItem(value: "Nowela", child: Text("Nowela")),
    DropdownMenuItem(value: "Poemat", child: Text("Poemat")),
    DropdownMenuItem(value: "Wiersz", child: Text("Wiersz")),
    DropdownMenuItem(value: "Dramat", child: Text("Dramat")),
  ];


  final List<DropdownMenuItem<String?>> epochItems = const [
    DropdownMenuItem(value: null, child: Text("Dowolna epoka")),
    DropdownMenuItem(value: "Średniowiecze", child: Text("Średniowiecze")),
    DropdownMenuItem(value: "Oświecenie", child: Text("Oświecenie")),
    DropdownMenuItem(value: "Romantyzm", child: Text("Romantyzm")),
    DropdownMenuItem(value: "Pozytywizm", child: Text("Pozytywizm")),
    DropdownMenuItem(value: "Modernizm", child: Text("Modernizm (Młoda Polska)")),
  ];


  final List<DropdownMenuItem<String?>> kindItems = const [
    DropdownMenuItem(value: null, child: Text("Dowolny rodzaj")),
    DropdownMenuItem(value: "Epika", child: Text("Epika")),
    DropdownMenuItem(value: "Liryka", child: Text("Liryka")),
    DropdownMenuItem(value: "Dramat", child: Text("Dramat (Rodzaj)")),
  ];

  String? _selectedGenre;
  String? _selectedEpoch;
  String? _selectedKind;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filtry biblioteki"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Szukaj po tytule lub autorze",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),


            DropdownButtonFormField<String?>(
              value: _selectedEpoch,
              items: epochItems,
              decoration: const InputDecoration(
                labelText: "Epoka",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedEpoch = value;
                });
              },
            ),
            const SizedBox(height: 16),


            DropdownButtonFormField<String?>(
              value: _selectedGenre,
              items: genreItems,
              decoration: const InputDecoration(
                labelText: "Gatunek",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
            ),
            const SizedBox(height: 16),


            DropdownButtonFormField<String?>(
              value: _selectedKind,
              items: kindItems,
              decoration: const InputDecoration(
                labelText: "Rodzaj",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedKind = value;
                });
              },
            ),
            const SizedBox(height: 24),


            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final filter = BookFilter(
                    search: searchController.text,
                    epoch: _selectedEpoch,
                    genre: _selectedGenre,
                    kind: _selectedKind,
                  );

                  Navigator.pop(context, filter);
                },
                child: const Text(
                  "Zastosuj filtry",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}