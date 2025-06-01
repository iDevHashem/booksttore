import 'package:bookstore_app/features/category/data/model/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'all_books_state.dart';

class AllBooksCubit extends Cubit<AllBooksState> {
  AllBooksCubit() : super(AllBooksInitial());

  List<BookModel>? books;

  Future<void> fetchBooks({Categories? category}) async {
    emit(AllBooksLoading());

    try {
      late final List<BookModel> fetchedBooks;
      if (category?.title != null && category!.title != "Science & Math") {
        fetchedBooks = [];
      } else {
        String _url;
        if (category == null) {
          //to load all books
          _url = "/books";

        } else {
          //to load specific category books
          _url = "/books?category=${category.title}";
        }

        final response = await DioHelper.getData(url: _url);
        fetchedBooks = (response.data['data']['books'] as List)
            .map((book) => BookModel.fromJson(book))
            .toList();
      }
      books = fetchedBooks;
      emit(AllBooksSuccess(books: fetchedBooks));
    } catch (e) {
      emit(AllBooksError(e.toString()));
    }
  }
}
