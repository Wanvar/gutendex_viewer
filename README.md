# Biblioteka Wolne Lektury

Aplikacja mobilna we Flutterze do przeglądania i pobierania e-booków z serwisu Wolne Lektury.

>  **Uwaga:** W kodzie zachowano nazwę roboczą `gutendex_viewer` by uniknąć problemów przestrzeni nazw, apilkacja obecnie pracuje jedynie z Wolne Lektury api.

---

##  Kluczowe funkcje

* **Paginacja:** Przeglądanie zasobów strona po stronie za pomocą dynamicznego paska nawigacji (`PaginationNavBar`).
* **Różne filtry:** Jednoczesne wyszukiwanie tekstem oraz filtrowanie po epoce, gatunku, rodzaju literackim i statusie zakładki.
* **System zakładek:** Zapisywanie stanu ulubionych książek. Zastosowano reaktywne UI – zmiana stanu w szczegółach od razu aktualizuje listę główną bez przeładowywania bazy.
* **Tryb Offline (Cache):** Architektura *Offline-First* oparta na bazie **Hive (NoSQL)**. Pobrane listy książek, filtry i zakładki działają bez dostępu do Internetu.
* **Pobieranie lektur:** Bezpośrednie linkowanie i otwieranie plików książek w formatach HTML, PDF oraz EPUB przy użyciu `url_launcher`.

---

##  Tech Stack & Architektura

* **Framework:** Flutter & Dart
* **Baza danych:** Hive / Hive CE (lokalny NoSQL)
* **Komunikacja:** HTTP Client & `url_launcher`

```text
lib/
├── designes/           # Komponenty UI (kafelki, nawigacja, filtry)
├── models/             # Modele danych (BookInfo, BookDetails, BookFilter)
├── services/           # Logika (SyncService, LocalDatabaseService, BookApiService2)
└── views/              # Ekrany (BookListView, BookDetailView)