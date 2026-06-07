class BookFilter {
  final String search;
  final String? epoch;
  final String? genre;
  final String? kind;

  BookFilter({
    required this.search,
    this.epoch,
    this.genre,
    this.kind
  });
}