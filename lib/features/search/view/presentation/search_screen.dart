

import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/search/view/presentation/custom_filter_dialog.dart';
import 'package:bookstore_app/features/search/view/search/search_cubit.dart';
import 'package:bookstore_app/features/search/view/search/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("Ganna : building Search Screen");
    final SearchCubit searchCubit = SearchCubit();
    return BlocProvider(
      create: (context) => searchCubit..fetchSearch..initialLoad(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 23),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (query) {
                              searchCubit.fetchSearch(query);
                            },
                            decoration: InputDecoration(
                              suffixIconColor: Colors.pinkAccent,
                              suffixIcon: Icon(Icons.search),
                              hintText: 'Search',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        // Filter button
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: FilterDialog(
                                                searchCubit: searchCubit),
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.filter_list, size: 20)),
                              SizedBox(width: 4),
                              Text('Filter'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // BlocBuilder for UI update based on Cubit states
                    SearchBody(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class SearchBody extends StatelessWidget {
  const SearchBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SearchError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is SearchSuccess) {
          // Render search results with spacing between items
          return ListView.separated(
            shrinkWrap: true, // Allow it to take the necessary space
            physics: NeverScrollableScrollPhysics(), // Disable internal scrolling
            itemCount: state.searchResults.length,
            itemBuilder: (context, index) {
              return BookCardItem(book: state.searchResults[index]);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12), // Space between items
          );
        }
        return Container(); // In case of SearchInitial state
      },
    );
  }
}

    
class BookCardItem extends StatelessWidget {
  const BookCardItem({
    required this.book,
    super.key,
  });

  final BookModel book;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 180,
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book.image ?? "", // Use image URL from book object
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipOval(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.favorite_border,
                                  color: Colors.pinkAccent,
                                ),
                                onPressed: () async {
                                  var x = await DioHelper.postData(
                                    url: '/add-to-wishlist',
                                    data: {'book_id': book.id},
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${x.data['message']}')),
                                  );
                                },
                              ),
                            ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            book.title ?? "", // Use title from book object
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Author: ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                TextSpan(
                  text: book.author, // Use author from book object
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.attach_money, color: Colors.black87, size: 18),
              Text(
                book.price ?? "0", // Use price from book object
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 13,
                ),
              ),
              SizedBox(width: 6),
              Text(
                book.priceAfterDiscount ??
                    "", // Use discounted price from book object
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.pinkAccent,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Spacer(),
              Icon(
                Icons.shopping_cart,
                color: Colors.pinkAccent,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
