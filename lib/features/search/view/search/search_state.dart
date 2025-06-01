

import 'package:bookstore_app/features/home/data/models/book_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<dynamic> searchResults; // أو نموذج معين حسب البيانات المسترجعة

  SearchSuccess(this.searchResults);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
abstract class AllBooksState {}

class AllBooksInitial extends AllBooksState {}

class AllBooksLoading extends AllBooksState {}

class AllBooksSuccess extends AllBooksState {
  final List<BookModel> books;

  AllBooksSuccess({required this.books});
}

class AllBooksError extends AllBooksState {
  final String message;

  AllBooksError(this.message);
}
