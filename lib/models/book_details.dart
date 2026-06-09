class BookDetails {
  final String slug;

  final String htmlUrl;
  final String pdfUrl;
  final String epubUrl;
  final bool hasAudiobook;
  final String notes;

  BookDetails({
    required this.slug,

    required this.htmlUrl,
    required this.pdfUrl,
    required this.epubUrl,
    required this.hasAudiobook,
    this.notes = "",
  });

  Map<String, dynamic> toMap() {
    return {
      "slug": slug,

      "htmlUrl": htmlUrl,
      "pdfUrl": pdfUrl,
      "epubUrl": epubUrl,
      "hasAudiobook": hasAudiobook,
      "notes": notes,
    };
  }

  factory BookDetails.fromMap(Map<String, dynamic> map, {String? fallbackSlug}) {

    final bool isFromHive = map.containsKey("htmlUrl");

    if (isFromHive) {
      return BookDetails(
        slug: map["slug"] ?? "",

        htmlUrl: map["htmlUrl"] ?? "",
        pdfUrl: map["pdfUrl"] ?? "",
        epubUrl: map["epubUrl"] ?? "",
        hasAudiobook: map["hasAudiobook"] ?? false,
        notes: map["notes"] ?? "",
      );
    }




    String parsedDescription = "Brak opisu dla tej pozycji.";
    if (map["fragment_data"] != null && map["fragment_data"] is Map) {
      parsedDescription = map["fragment_data"]["html"] ?? map["fragment_data"]["title"] ?? parsedDescription;
    } else if (map["description"] is String) {
      parsedDescription = map["description"];
    }


    bool audiobookAvailable = false;
    if (map["media"] != null && map["media"] is List) {
      final List mediaList = map["media"] as List;

      audiobookAvailable = mediaList.any((element) => element is Map && element["type"] == "mp3");
    }

    return BookDetails(

      slug: map["slug"] ?? fallbackSlug ?? "",

      htmlUrl: map["html"] ?? "",
      pdfUrl: map["pdf"] ?? "",
      epubUrl: map["epub"] ?? "",
      hasAudiobook: audiobookAvailable,
      notes: map["notes"] ?? "",
    );
  }

  BookDetails copyWith({
    String? slug,
    String? description,
    String? htmlUrl,
    String? pdfUrl,
    String? epubUrl,
    bool? hasAudiobook,
    String? notes,
  }) {
    return BookDetails(
      slug: slug ?? this.slug,

      htmlUrl: htmlUrl ?? this.htmlUrl,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      epubUrl: epubUrl ?? this.epubUrl,
      hasAudiobook: hasAudiobook ?? this.hasAudiobook,
      notes: notes ?? this.notes,
    );
  }
}