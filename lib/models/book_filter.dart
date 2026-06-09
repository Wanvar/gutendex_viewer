class BookFilter {
  final String search;
  final bool showOnlyMarked;
  final String? epoch;
  final String? genre;
  final String? kind;

  BookFilter({
    required this.search,
    required this.showOnlyMarked,
    this.epoch,
    this.genre,
    this.kind
  });
}