import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/category/data/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/all_books_cubit.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/all_books_state.dart';

class AllBooksScreen extends StatelessWidget {
  const AllBooksScreen({super.key,this.categories});
final Categories?categories;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllBooksCubit()..fetchBooks( category: categories),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text("All Books"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const AllBooksItem(),
      ),
    );
  }
}

class AllBooksItem extends StatelessWidget {
  const AllBooksItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllBooksCubit, AllBooksState>(
      builder: (context, state) {
        if (state is AllBooksLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AllBooksError) {
          return Center(child: Text(state.message));
        } else if (state is AllBooksSuccess) {
          if(state.books.length ==0||state.books.isEmpty){
            return Center(child:Text("No books"));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: state.books.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final book = state.books[index];
                return BookCard(book: book);
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class BookCard extends StatefulWidget {
  final BookModel book;

  const BookCard({super.key, required this.book});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isWishlisted = false;
  bool isInCart = false;

  void toggleWishlist() async {
    try {
      var response = await DioHelper.postData(
        url: '/add-to-wishlist',
        data: {'book_id': widget.book.id},
      );
      setState(() {
        isWishlisted = !isWishlisted;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data['message'] ?? 'Updated wishlist')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding to wishlist')),
      );
    }
  }

  void toggleCart() async {
    try {
      var response = await DioHelper.postData(
        url: '/add-to-cart',
        data: {'book_id': widget.book.id},
      );
      setState(() {
        isInCart = !isInCart;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data['message'] ?? 'Updated cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding to cart')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.book.image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: Colors.pinkAccent,
                    ),
                    onPressed: toggleWishlist,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Author: ${widget.book.author}",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.attach_money, size: 16, color: Colors.black),
              Text(
                widget.book.priceAfterDiscount ?? widget.book.price,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  isInCart
                      ? Icons.shopping_cart
                      : Icons.shopping_cart_outlined,
                  color: Colors.pink,
                  size: 18,
                ),
                onPressed: toggleCart,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
