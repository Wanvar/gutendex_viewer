import 'package:flutter/material.dart';

class BookFilter {
  final String search;
  final String? language;
  final String? subject;

  BookFilter({
    required this.search,
    this.language,
    this.subject,
  });
}

class BookFilterScreen extends StatelessWidget {
  BookFilterScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  final List<DropdownMenuItem<String?>> languageItems = const [
    DropdownMenuItem(value: null, child: Text("Dowolny język")),
    DropdownMenuItem(value: "eng", child: Text("English")),
    DropdownMenuItem(value: "pol", child: Text("Polski")),
    DropdownMenuItem(value: "ger", child: Text("Deutsch")),
    DropdownMenuItem(value: "fre", child: Text("Français")),
    DropdownMenuItem(value: "spa", child: Text("Español")),
  ];

  final List<DropdownMenuItem<String?>> subjectItems = const [
    DropdownMenuItem(value: null, child: Text("Dowolny gatunek")),
    DropdownMenuItem(value: "fantasy", child: Text("Fantasy")),
    DropdownMenuItem(value: "science_fiction", child: Text("Science Fiction")),
    DropdownMenuItem(value: "history", child: Text("Historia")),
    DropdownMenuItem(value: "romance", child: Text("Romans")),
    DropdownMenuItem(value: "nature", child: Text("Przyroda")),
  ];

  String? _selectedLanguage;
  String? _selectedSubject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filtry książek"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Szukaj",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String?>(
              value: _selectedLanguage,
              items: languageItems,
              decoration: const InputDecoration(
                labelText: "Język",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _selectedLanguage = value;
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String?>(
              value: _selectedSubject,
              items: subjectItems,
              decoration: const InputDecoration(
                labelText: "Gatunek",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _selectedSubject = value;
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final filter = BookFilter(
                  search: searchController.text,
                  language: _selectedLanguage,
                  subject: _selectedSubject,
                );

                Navigator.pop(context, filter);
              },
              child: const Text("Zastosuj filtry"),
            ),
          ],
        ),
      ),
    );
  }
}