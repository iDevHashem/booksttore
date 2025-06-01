import 'package:bookstore_app/features/home/view/view_model/cubit/book_details_cubit.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/book_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';

class BookDetailsScreen extends StatefulWidget {
  final int bookId;

  const BookDetailsScreen({super.key, required this.bookId});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool isInWishlist = false;
  bool isInCart = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookDetailsCubit()..fetchBookDetails(widget.bookId),
      child: BlocBuilder<BookDetailsCubit, BookDetailsState>(
        builder: (context, state) {
          if (state is BookDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookDetailsSuccess) {
            final book = state.book;

            if (book == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Book Details')),
                body: const Center(child: Text('No details available for this book')),
              );
            }

            return Scaffold(
              appBar: AppBar(title: const Text('Book Details')),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        book.image ?? "",
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      book.title ?? 'No title available',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Author: ${book.author ?? 'Unknown'}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, size: 18),
                        Text(
                          book.priceAfterDiscount ?? book.price ?? '0',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (book.priceAfterDiscount != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            book.price ?? '0',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.pink,
                              decoration: TextDecoration.lineThrough,
                            ),
                          )
                        ],
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Description',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _ExpandableDescription(
                      text: book.description ?? 'No description available',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                            color: isInCart ? Colors.green : Colors.black,
                          ),
                          onPressed: () async {
                            setState(() {
                              isInCart = true;
                            });

                            try {
                              final res = await DioHelper.postData(
                                url: '/add-to-cart',
                                data: {'book_id': book.id},
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(res.data['message'] ?? 'Added to cart')),
                              );
                            } catch (e) {
                              setState(() {
                                isInCart = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Something went wrong')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            isInWishlist ? Icons.favorite : Icons.favorite_border,
                            color: Colors.pinkAccent,
                          ),
                          onPressed: () async {
                            setState(() {
                              isInWishlist = true;
                            });

                            try {
                              final res = await DioHelper.postData(
                                url: '/add-to-wishlist',
                                data: {'book_id': book.id},
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(res.data['message'] ?? 'Added to wishlist')),
                              );
                            } catch (e) {
                              setState(() {
                                isInWishlist = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Something went wrong')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (state is BookDetailsError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Book Details')),
              body: Center(child: Text(state.message)),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ------------------- Expandable Description Widget -------------------
class _ExpandableDescription extends StatefulWidget {
  final String text;

  const _ExpandableDescription({required this.text});

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: isExpanded ? null : 3,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isExpanded ? 'See less' : 'See more',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.pinkAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
