import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/home/view/view_model/home_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/home/view/presentation/book_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/home_state.dart';

class RecommendedViewItem extends StatelessWidget {
  const RecommendedViewItem({
    super.key,
    required this.book,
    this.showDiscount = false,
  });

  final BookModel book;
  final bool showDiscount;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final controller = BlocProvider.of<HomeCubit>(context);

        Future<void> toggleWishlist() async {
          try {
            if (book.isFavourite) {
              var response = await DioHelper.postData(
                url: '/remove-from-wishlist',
                data: {'book_id': book.id},
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${response.data['message']}')),
              );
            } else {
              var response = await DioHelper.postData(
                url: '/add-to-wishlist',
                data: {'book_id': book.id},
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${response.data['message']}')),
              );
            }
            // تحديث الحالة محليًا
            book.isFavourite = !book.isFavourite;
            // controller.emit(HomeUpdateState()); // أو أي State مناسبة للتحديث
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating wishlist')),
            );
          }
        }

        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BookDetailsScreen(bookId: book.id!),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.white,
              height: 150,
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 555 / 700,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: '${book.image}',
                        errorWidget: (context, url, error) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          book.title ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Author: ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: book.author ?? '',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text("EGP"),
                                const SizedBox(width: 5),
                                Text(
                                  showDiscount
                                      ? (book.priceAfterDiscount ?? book.price ?? '')
                                      : (book.price ?? ''),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.pinkAccent,
                                  ),
                                  onPressed: () {
                                    controller.addCartProduct(book.id);
                                  },
                                ),
                                ClipOval(
                                  child: IconButton(
                                    icon: Icon(
                                      book.isFavourite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.pink,
                                    ),
                                    onPressed: toggleWishlist,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
