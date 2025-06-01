import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  late final List<BookModel> _allBooks;
  double? filteredPrice;
  List<BookModel> _activeBooks=[];
  String? selectedCategory;
  
  Future<void> initialLoad() async {
    print("initialLoad");
    emit(SearchLoading());
    try {
      final response = await DioHelper.getData(url: "/books");
      _allBooks = (response.data['data']['books'] as List)
          .map((book) => BookModel.fromJson(book))
          .toList();

          _activeBooks = _allBooks;
      emit(SearchSuccess(_filterBooksByPrice(_activeBooks)));
      
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'خطأ في الاتصال بالسيرفر';
      emit(SearchError(message));
    } catch (e) {
      emit(SearchError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> fetchSearch(String? query) async {
    emit(SearchLoading());

    try {
      if (query == null || query.isEmpty) {
        _activeBooks = _allBooks;
        emit(SearchSuccess(_filterBooksByPrice(_activeBooks)));
        return;
      }
      final response = await DioHelper.getData(
        url: '/books-search',
        query: {'title': query}, // استخدم المتغير المرسل
      );

      final List<dynamic>? booksJson = response.data['data']['books'];
      final books =
          booksJson?.map((json) => BookModel.fromJson(json)).toList() ?? [];
_activeBooks = books;
      emit(SearchSuccess(_filterBooksByPrice(_activeBooks)));
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'خطأ في الاتصال بالسيرفر';
      emit(SearchError(message));
    } catch (e) {
      emit(SearchError('حدث خطأ غير متوقع'));
    }
  }

 List<BookModel> _filterBooksByPrice(List<BookModel> books) {
  final x = books.where((book) {
    // Parse the price string to int or double safely
    final price = double.tryParse(book.price) ?? 0;
    final tempPrice = filteredPrice??5500000550;
    return price <= tempPrice;
  }).toList();

  print("Ganna: books List ${x.length}");
  return x;
}
 
  Future<void> setFilterbyPrice(double price)async{
    print("Ganna: Filter by price");
    filteredPrice = price;
    emit(SearchSuccess(_filterBooksByPrice(_activeBooks)));
  }

/// Not Used
  Future<void> fetchFilteredBooks({String? category, int? price}) async {
    emit(SearchLoading());

    try {
      final response = await DioHelper.getData(
        url: 'books-filter',
        query: {
          if (category != null) 'category': category,
          if (price != null) 'price': price.toString(),
        },
      );

      if (response.statusCode == 200) {
        final List booksJson = response.data['data']['books'];

        List<BookModel> filteredBooks = [];
        for (int i = 0; i < booksJson.length; i++) {
          BookModel x = BookModel.fromJson(booksJson[i]);
          filteredBooks.add(x);
        }
        emit(SearchSuccess(filteredBooks));
      } else {
        emit(SearchError(response.data["message"] ?? 'حدث خطأ غير متوقع'));
      }
    } catch (e) {
      emit(SearchError('فشل الاتصال بالخادم: $e'));
    }
  }

}
