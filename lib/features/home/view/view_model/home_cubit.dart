import 'dart:async';

import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/home/view/view_model/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/magic_router/magic_router.dart';
import '../../../../core/utils/snack_bar.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitState());

  HomeCubit get(context) => BlocProvider.of(context);

  List<BookModel>? books;

  getlimitBooks() async {
    emit(GetLimitBooksLoadingState());


    await DioHelper.getData(url: "/books", query: {'limit': 2}).then((value) async {
      books = List<BookModel>.from(
        value.data['data']['books'].map((book) => BookModel.fromJson(book)),
      );


      emit(GetLimitBooksSucessState(books: books!));
    }).onError(
      (error, stackTrace) {
        emit(GetLimitBooksErrorState());
      },
    );
  }


  addCartProduct(int bookId) async {
    emit(AddProductLoading());

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final context = MagicRouter.currentContext;

    try {
      final response = await DioHelper.postData(
        url: '/add-to-cart',
        data: {'book_id': bookId},
        token: token,
      );

      final data = response.data as Map<String, dynamic>;

      if (data['status'] == true) {
        emit(AddProductSuccess());
        if (context != null) {
          Utils.showSnackBar(context, data['message']);
        }
      } else {
        emit(AddProductFailed());
        if (context != null) {
          Utils.showSnackBar(context, data["message"]);
        }
      }
    } catch (e) {
      //emit(AddProductFailed());
      if (context != null) {
        Utils.showSnackBar(context, 'An error occurred: ${e.toString()}');
      }
    }
  }


  Future<void> getFavouriteBooks()async {
      final response = await DioHelper.getData(url: '/show-wishlist', query: {});
      final List<dynamic>? wishlistJson = response.data['data']['books'];
      final favouriteBooks = wishlistJson?.map((json) => BookModel.fromJson(json)).toList() ?? [];
  }


}
