class BookDetails {
  final String slug;
  final String description;
  final String htmlUrl;
  final String pdfUrl;
  final String epubUrl;
  final bool hasAudiobook;
  final String notes;

  BookDetails({
    required this.slug,
    required this.description,
    required this.htmlUrl,
    required this.pdfUrl,
    required this.epubUrl,
    required this.hasAudiobook,
    this.notes = "",
  });

  Map<String, dynamic> toMap() {
    return {
      "slug": slug,
      "description": description,
      "htmlUrl": htmlUrl,
      "pdfUrl": pdfUrl,
      "epubUrl": epubUrl,
      "hasAudiobook": hasAudiobook,
      "notes": notes,
    };
  }

  factory BookDetails.fromMap(Map<String, dynamic> map) {
    final bool isFromHive = map.containsKey("htmlUrl");

    if (isFromHive) {
      return BookDetails(
        slug: map["slug"] ?? "",
        description: map["description"] ?? "",
        htmlUrl: map["htmlUrl"] ?? "",
        pdfUrl: map["pdfUrl"] ?? "",
        epubUrl: map["epubUrl"] ?? "",
        hasAudiobook: map["hasAudiobook"] ?? false,
        notes: map["notes"] ?? "", // Przywracanie notatki z dysku
      );
    }

    final List audiobooksList = map["audiobooks"] ?? [];

    return BookDetails(
      slug: map["slug"] ?? "",
      description: map["fragment_data"] ?? map["description"] ?? "Brak opisu dla tej pozycji.",
      htmlUrl: map["html"] ?? "",
      pdfUrl: map["pdf"] ?? "",
      epubUrl: map["epub"] ?? "",
      hasAudiobook: audiobooksList.isNotEmpty,
      notes: map["notes"] ?? "",
    );
  }


  BookDetails copyWith({
    String? description,
    String? htmlUrl,
    String? pdfUrl,
    String? epubUrl,
    bool? hasAudiobook,
    String? notes,
  }) {
    return BookDetails(
      slug: this.slug,
      description: description ?? this.description,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      hasAudiobook: hasAudiobook ?? this.hasAudiobook,
      epubUrl: epubUrl ?? this.epubUrl,
      notes: notes ?? this.notes,
    );
  }
}