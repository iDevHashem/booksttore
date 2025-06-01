// import 'package:bookstore_app/features/profile/profile_screen.dart';
// import 'package:flutter/material.dart';
//
// class PersonalDataPage extends StatelessWidget {
//   final TextEditingController nameController =
//       TextEditingController(text: 'Shahd Ahmed');
//   final TextEditingController emailController =
//       TextEditingController(text: 'shahdahmed@gmail.com');
//   final TextEditingController phoneController =
//       TextEditingController(text: '01012345678');
//   final TextEditingController cityController =
//       TextEditingController(text: 'Cairo');
//   final TextEditingController addressController =
//       TextEditingController(text: 'Maadi, Cairo, Egypt');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF9F9F9),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           'Edit Profile',
//           style: TextStyle(color: Colors.black),
//         ),
//         iconTheme: IconThemeData(color: Colors.black),
//         leading: BackButton(),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: AssetImage('assets/image/profile.jpg'),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             _buildLabel('Name'),
//             _buildInputFeild(controller: nameController),
//             _buildLabel('Email'),
//             _buildInputFeild(controller: emailController),
//             _buildLabel('Phone Number'),
//             _buildInputFeild(controller: phoneController),
//             _buildLabel('City'),
//             _buildInputFeild(controller: cityController),
//             _buildLabel('Address'),
//             _buildInputFeild(controller: addressController),
//             SizedBox(
//               height: 30,
//             ),
//             ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.pink,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
//                 child: Text(
//                   'Save',
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLabel(String label) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Padding(
//         padding: const EdgeInsets.only(top: 20.0, bottom: 5),
//         child: Text(
//           label,
//           style: TextStyle(color: Colors.grey[700]),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputFeild({required TextEditingController controller}) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
//     );
//   }
// }
