import 'package:bookstore_app/features/onboarding/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/image/books_im.jpg',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fill),
          Positioned(
              top: 250,
              left: 100,
              child: SvgPicture.asset(
                'assets/logo.svg',
                height: 50,
                width: 85,
              )),
        ],
      ),
    );
  }
}
