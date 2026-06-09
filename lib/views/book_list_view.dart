
import 'package:flutter/material.dart';
import 'package:gutendex_viewer/services/sync_service.dart';
import '../models/book_info.dart';
import '../designes/book_list_tile.dart';
import '../designes/pagination_nav_bar.dart';
import '../designes/book_filter.dart';
import '../models/book_filter.dart';
import '../views/book_detail_view.dart';

class BookListView extends StatefulWidget {
  const BookListView({super.key});

  @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  final SyncService _syncService = SyncService();
  late Future<List<BookInfo>> _booksFuture;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    setState(() {
      BookFilter filter = BookFilter(search: "", showOnlyMarked: false);
      _syncService.updateFilter(filter);
      _booksFuture = _syncService.fetchPage(page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text(
          "Biblioteka Wolne Lektury",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.indigo[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
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
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<BookInfo>>(
              future: _booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Coś poszło nie tak: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {});
                  });
                  final List<BookInfo> books = snapshot.data!;

                  if (books.isEmpty) {
                    return const Center(
                        child: Text("Brak książek spełniających kryteria."));
                  }

                  loaded = true;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                        child: Text(
                          "Wyszukane pozycje:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),

                      Expanded(
                        child: ListView.separated(
                          itemCount: books.length,
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          separatorBuilder: (context, index) => const SizedBox(height: 4),
                          itemBuilder: (context, index) {
                            return BookListTile(
                              book: books[index],
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookDetailView(
                                          bookInfo: books[index])),
                                );
                                final updatedBook = _syncService.getBookInfo(
                                    books[index].slug);

                                if (updatedBook != null) {
                                  setState(() {
                                    books[index] = updatedBook;
                                  });
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

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
        onNextPressed: () => setState(() {
          loaded = false;
          _booksFuture = _syncService.fetchPage(offset: 1);
        }),
        currentPage: _syncService.currentPage.toString(),
        maxPages: _syncService.maxPage.toString(),
      ),
    );
  }
}