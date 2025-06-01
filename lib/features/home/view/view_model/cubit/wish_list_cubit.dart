import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/wish_list_state.dart';

class WishListCubit extends Cubit<WishListState> {
  WishListCubit() : super(WishListInitial());

  List<BookModel> _currentBooks = [];

  Future<void> fetchWishlist() async {
    emit(WishListLoading());

    try {
      final response = await DioHelper.getData(url: '/show-wishlist', query: {});
      final List<dynamic>? wishlistJson = response.data['data']['books'];
      final books = wishlistJson?.map((json) => BookModel.fromJson(json)).toList() ?? [];

      _currentBooks = books;
      emit(WishListSuccess(books));
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'خطأ في الاتصال بالسيرفر';
      emit(WishListError(message));
    } catch (e) {
      emit(WishListError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> removeFromWishlist(int bookId) async {
    try {
      await DioHelper.postData(
        url: '/remove-from-wishlist',
        data: {'book_id': bookId},
      );

      // إزالة العنصر محليًا بدون إعادة جلب من السيرفر
      _currentBooks.removeWhere((book) => book.id == bookId);
      emit(WishListSuccess(List.from(_currentBooks))); // إعادة بناء الحالة
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'فشل في الحذف';
      emit(WishListError(message));
    } catch (e) {
      emit(WishListError('حدث خطأ غير متوقع أثناء الحذف'));
    }
  }
}
