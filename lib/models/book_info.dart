class BookInfo {
  final String slug;
  final String title;
  final String author;
  final String epoch;
  final String genre;
  final String kind;
  final String coverUrl;
  final bool isMarked;


  BookInfo({
    required this.slug,
    required this.title,
    required this.author,
    required this.epoch,
    required this.genre,
    required this.kind,
    required this.coverUrl,
    this.isMarked = false,

  });


  Map<String, dynamic> toMap() {
    return {
      "slug": slug,
      "title": title,
      "author": author,
      "epoch": epoch,
      "genre": genre,
      "kind": kind,
      "coverUrl": coverUrl,
      "isMarked": isMarked,

    };
  }


  factory BookInfo.fromMap(Map<String, dynamic> map) {
    return BookInfo(
      slug: map["slug"] ?? "",
      title: map["title"] ?? "Brak tytułu",
      author: map["author"] ?? "Nieznany autor",
      epoch: map["epoch"] ?? "Nieznana epoka",
      genre: map["genre"] ?? "Brak gatunku",
      kind: map["kind"] ?? "Brak rodzaju",
      coverUrl: map["coverUrl"] ?? map["simple_thumb"] ?? "",
      isMarked: map["isMarked"] ?? false,

    );
  }

  BookInfo copyWith({
    bool? isMarked,
    String? notes,
  }) {
    return BookInfo(
      slug: this.slug,
      title: this.title,
      author: this.author,
      epoch: this.epoch,
      genre: this.genre,
      kind: this.kind,
      coverUrl: this.coverUrl,
      isMarked: isMarked ?? this.isMarked,

    );
  }
}