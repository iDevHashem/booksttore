import 'package:bookstore_app/core/utils/app_colors.dart';
import 'package:bookstore_app/core/utils/text_style.dart';
import 'package:bookstore_app/core/widgets/custome_elevated_button.dart';
import 'package:bookstore_app/features/auth/views/presentation/create_account_screen.dart';
import 'package:bookstore_app/features/auth/views/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/image/books_im.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            top: 170,
            left: 10,
            right: 10,
            child: Column(
              children: [
                SvgPicture.asset('assets/logo.svg', height: 50, width: 85),
                SizedBox(height: 60),
                CustomElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    text: 'Login'),
                SizedBox(height: 15),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAccountPage()),
                    );
                  },
                  backgroundColor: AppColors.white,
                  text: 'Create Account',
                  textStyle: getBodyStyle(color: AppColors.primary),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
