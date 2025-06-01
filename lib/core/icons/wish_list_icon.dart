import 'package:bookstore_app/features/home/view/presentation/wish_list_screen.dart';
import 'package:flutter/material.dart';

class WishListIcon extends StatefulWidget {
  const WishListIcon({super.key});

  @override
  State<WishListIcon> createState() => _WishListIconState();
}

class _WishListIconState extends State<WishListIcon> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WishListScreen()),
        );
      },
      icon: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.pinkAccent,
              width: 2,
            )),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.pinkAccent : Colors.grey,
            size: 28,
          ),
        ),
      ),
    );
  }
}
