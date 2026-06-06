import 'package:flutter/material.dart';
import 'package:gutendex_viewer/services/sync_service.dart';
import '../models/book.dart';
import '../services/book_api_service.dart';
import '../designes/book_list_tile.dart';
import '../designes/pagination_nav_bar.dart';
import '../designes/book_filter.dart';

class BookListView extends StatefulWidget {
  const BookListView({super.key});

  @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {

  final SyncService _syncService = SyncService();
  late Future<List<Book>> _booksFuture;
  bool loaded = false;
  String _selectedLanguage = "all"; // Domyślny filtr językowy

  @override
  void initState() {
    super.initState();

    _loadBooks();
  }

  void _loadBooks() {
    setState(() {
      BookFilter filter = BookFilter(search: "classic");
      _syncService.updateFilter(filter);
      _booksFuture = _syncService.fetchPage(page: 1);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Biblioteka Gutenberg"),
        actions: [IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () async {
            final filter = await Navigator.push<BookFilter>(
              context,
              MaterialPageRoute(
                builder: (_) => BookFilterScreen(),
              ),
            );

            if (filter != null) {
              _syncService.updateFilter(filter);

              setState(() {
                loaded = false;
                _booksFuture = _syncService.fetchPage(page: 1);
              });
            }
          },
        ),],
      ),

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
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {});
                  });
                  final List<Book> books = snapshot.data!;

                  if (books.isEmpty) {
                    return const Center(child: Text("Brak książek spełniających kryteria."));
                  }

                  loaded = true;
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

      bottomNavigationBar: PaginationNavBar(
        hasPrevious: _syncService.hasPrev,
        hasNext: _syncService.hasNext,
        isLoading: !loaded,
        onPreviousPressed: () => setState(() {

            loaded = false;
            _booksFuture = _syncService.fetchPage(offset: -1);


        }),
        onNextPressed: () =>  setState(() {

          loaded = false;
            _booksFuture = _syncService.fetchPage(offset: 1);

        }),
      ),
    );
  }
}
