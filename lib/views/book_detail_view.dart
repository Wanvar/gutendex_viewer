import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/book_info.dart';
import '../models/book_details.dart';
import '../services/sync_service.dart';

class BookDetailView extends StatefulWidget {
  final BookInfo bookInfo;

  const BookDetailView({
    super.key,
    required this.bookInfo,
  });

  @override
  State<BookDetailView> createState() => _BookDetailViewState();
}

class _BookDetailViewState extends State<BookDetailView> {
  final SyncService _syncService = SyncService();

  late Future<BookDetails> _bookDetailsFuture;
  late bool _isMarked;

  @override
  void initState() {
    super.initState();
    _isMarked = widget.bookInfo.isMarked;
    _bookDetailsFuture =
        _syncService.fetchBookDetails(widget.bookInfo.slug);
  }



  Future<void> _launchUrlHelper(String url) async {


    if (url.isEmpty) return;

    final uri = Uri.tryParse(url);
    if (uri == null) return;

    log("${uri.toString()}", name: "details");
    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nie można otworzyć linku')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Szczegóły książki"),
        actions: [
          IconButton(
            icon: Icon(
              _isMarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: _isMarked ? Colors.purple : null,
            ),
            onPressed: () async {
              await _syncService.toggleMarkBook(widget.bookInfo.slug);
              setState(() {
                _isMarked = !_isMarked;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<BookDetails>(
        future: _bookDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text('Błąd ładowania danych'),
            );
          }

          final details = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                Container(
                  width: 160,
                  height: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: widget.bookInfo.coverUrl.isNotEmpty
                      ? Image.network(
                    widget.bookInfo.coverUrl,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.menu_book, size: 48),
                ),

                const SizedBox(height: 24),


                Text(
                  widget.bookInfo.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.bookInfo.author,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.indigo[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),


                _buildInfoRow(Icons.history_toggle_off_rounded,
                    "Epoka", widget.bookInfo.epoch),
                _buildInfoRow(Icons.category_rounded,
                    "Gatunek", widget.bookInfo.genre),
                _buildInfoRow(Icons.auto_stories_rounded,
                    "Rodzaj", widget.bookInfo.kind),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),


                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Dostępne opcje lektury:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),


                if (details.htmlUrl.isNotEmpty)
                  _buildButton(
                    label: "Czytaj online (HTML)",
                    icon: Icons.open_in_browser,
                    color: Colors.indigo,
                    onTap: () =>
                        _launchUrlHelper("https://wolnelektury.pl/katalog/lektura/${widget.bookInfo.slug}.html"),
                  ),


                if (details.pdfUrl.isNotEmpty)
                  _buildOutlinedButton(
                    label: "Pobierz PDF",
                    icon: Icons.picture_as_pdf,
                    color: Colors.red,
                    onTap: () =>
                        _launchUrlHelper(details.pdfUrl),
                  ),


                if (details.epubUrl.isNotEmpty)
                  _buildOutlinedButton(
                    label: "Pobierz EPUB",
                    icon: Icons.book,
                    color: Colors.teal,
                    onTap: () =>
                        _launchUrlHelper(details.epubUrl),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onTap,
          icon: Icon(icon),
          label: Text(label),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onTap,
          icon: Icon(icon, color: color),
          label: Text(label),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon,
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey[600]),
          const SizedBox(width: 14),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}