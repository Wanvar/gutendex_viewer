import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_api_service.dart';
import '../designes/book_list_tile.dart';

class BookListView extends StatefulWidget {
  const BookListView({super.key});

  @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {

  late Future<List<Book>> _booksFuture;
  String _selectedLanguage = "all"; // Domyślny filtr językowy

  @override
  void initState() {
    super.initState();

    _loadBooks();
  }

  void _loadBooks() {
    setState(() {

      _booksFuture = BookApiService.fetchBooks(lang: _selectedLanguage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Biblioteka Gutenberg")),
      body: Column(
        children: [

          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _booksFuture,
              builder: (context, snapshot) {


                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }


                else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Coś poszło nie tak: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                }


                else if (snapshot.hasData) {
                  final List<Book> books = snapshot.data!;

                  if (books.isEmpty) {
                    return const Center(child: Text("Brak książek spełniających kryteria."));
                  }


                  return ListView.separated(
                    itemCount: books.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return BookListTile(
                        book: books[index],
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => BookDetailView(bookId: books[index].id),
                          //   ),
                          // );
                        },
                      );
                    },
                  );
                }

                // Stan domyślny (zabezpieczający)
                return const Center(child: Text("Brak danych."));
              },
            ),
          ),
        ],
      ),
    );
  }
}
