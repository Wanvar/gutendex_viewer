// class FilterOptions {
//   final List<FilterItem> epochs;
//   final List<FilterItem> genres;
//   final List<FilterItem> kinds;
//   final List<FilterItem> themes;
//   final List<FilterItem> collections;
//   final List<FilterItem> authors;
//
//   FilterData({
//     required this.epochs,
//     required this.genres,
//     required this.kinds,
//     required this.themes,
//     required this.collections,
//     required this.authors,
//   });
//
//   factory FilterData.empty() => FilterData(
//     epochs: [],
//     genres: [],
//     kinds: [],
//     themes: [],
//     collections: [],
//     authors: [],
//   );
//
//
//   Map<String, dynamic> toMap() {
//     return {
//       'epochs': epochs.map((e) => e.toMap()).toList(),
//       'genres': genres.map((g) => g.toMap()).toList(),
//       'kinds': kinds.map((k) => k.toMap()).toList(),
//       'themes': themes.map((t) => t.toMap()).toList(),
//       'collections': collections.map((c) => c.toMap()).toList(),
//       'authors': authors.map((a) => a.toMap()).toList(),
//     };
//   }
//
//   factory FilterData.fromMap(Map<String, dynamic> map) {
//     return FilterData(
//       epochs: (map['epochs'] as List? ?? []).map((e) => FilterItem.fromMap(e)).toList(),
//       genres: (map['genres'] as List? ?? []).map((g) => FilterItem.fromMap(g)).toList(),
//       kinds: (map['kinds'] as List? ?? []).map((k) => FilterItem.fromMap(k)).toList(),
//       themes: (map['themes'] as List? ?? []).map((t) => FilterItem.fromMap(t)).toList(),
//       collections: (map['collections'] as List? ?? []).map((c) => FilterItem.fromMap(c)).toList(),
//       authors: (map['authors'] as List? ?? []).map((a) => FilterItem.fromMap(a)).toList(),
//     );
//   }
// }