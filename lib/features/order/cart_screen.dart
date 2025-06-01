// import 'package:bookstore_app/features/checkout/view/presentation/checkout_screen.dart';
// import 'package:bookstore_app/features/order/checkout_screen.dart';
// import 'package:flutter/material.dart';
//
// class CartPage extends StatelessWidget {
//   const CartPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My cart'),
//         leading: const BackButton(),
//       ),
//       body: Column(
//         children: [
//           const CartItem(),
//           const Divider(),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Column(
//               children: [
//                 summaryRow('Subtotal', '\$120'),
//                 summaryRow('Shipping', 'Free Delivery'),
//                 summaryRow('Tax', '\$4'),
//                 const SizedBox(height: 10),
//                 summaryRow('Total', '\$124', isTotal: true),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: SizedBox(
//           height: 80,
//           child: Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => CheckoutScreen()),
//                       );
//                     },
//                     icon: const Icon(
//                       Icons.arrow_forward,
//                       color: Colors.white,
//                     ),
//                     label: const Text('Check out',
//                         style: TextStyle(color: Colors.white)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.pink,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget summaryRow(String title, String value, {bool isTotal = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title,
//               style: TextStyle(
//                   fontSize: isTotal ? 18 : 16,
//                   fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
//           Text(value,
//               style: TextStyle(
//                   fontSize: isTotal ? 18 : 16,
//                   color: isTotal ? Colors.pink : null,
//                   fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
//         ],
//       ),
//     );
//   }
// }
//
// class CartItem extends StatelessWidget {
//   const CartItem({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             Image.network(
//               'https://m.media-amazon.com/images/I/81bsw6fnUiL.jpg',
//               width: 80,
//               height: 100,
//               fit: BoxFit.cover,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text(
//                     'Rich Dad And Poor Dad',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   Text('Author: Robert T. Kiyosaki'),
//                   SizedBox(height: 4),
//                   Text('\$40.00',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                   Text('ASIN: B09TWSRMCB',
//                       style: TextStyle(fontSize: 12, color: Colors.grey)),
//                 ],
//               ),
//             ),
//             Column(
//               children: [
//                 IconButton(onPressed: () {}, icon: const Icon(Icons.remove)),
//                 const Text('1'),
//                 IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
