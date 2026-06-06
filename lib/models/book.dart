class Book {
  final int id;
  final String title;
  final String author;
  final String language;
  final String formatHtmlUrl;
  final int downloadCount;
  final bool isMarked;
  final String notes;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.language,
    required this.formatHtmlUrl,
    required this.downloadCount,
    this.isMarked = false,
    this.notes = "",
  });


  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "author": author,
      "language": language,
      "formatHtmlUrl": formatHtmlUrl,
      "downloadCount": downloadCount,
      "isMarked": isMarked,
      "notes": notes,
    };
  }


  factory Book.fromMap(Map<String, dynamic> map) {

    final List authorsList = map["authors"] ?? [];
    String authorName = "Nieznany autor";
    if (authorsList.isNotEmpty) {
      authorName = authorsList[0]["name"] ?? "Nieznany autor";
    }

    final List languagesList = map["languages"] ?? [];
    String lang = languagesList.isNotEmpty ? languagesList[0] : "en";

    final Map<String, dynamic> formatsMap = map["formats"] ?? {};
    String htmlUrl = formatsMap["text/html"] ?? "https://www.gutenberg.org";

    return Book(
      id: map["id"],
      title: map["title"] ?? "Brak tytułu",
      author: map["author"] ?? authorName,
      language: map["language"] ?? lang,
      formatHtmlUrl: map["formatHtmlUrl"] ?? htmlUrl,
      downloadCount: map["download_count"] ?? map["downloadCount"] ?? 0,
      isMarked: map["isMarked"] ?? false,
      notes: map["notes"] ?? "",
    );
  }


  Book copyWith({
    bool? isMarked,
    String? notes,
  }) {
    return Book(
      id: this.id,
      title: this.title,
      author: this.author,
      language: this.language,
      formatHtmlUrl: this.formatHtmlUrl,
      downloadCount: this.downloadCount,
      isMarked: isMarked ?? this.isMarked,
      notes: notes ?? this.notes,
    );
  }
}