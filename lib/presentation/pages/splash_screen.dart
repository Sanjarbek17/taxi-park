import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taxi_park/core/custom_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: CustomColors.secondaryColor,
      body: Center(
        child: SvgPicture.asset('assets/icons/logo.svg'),
      ),
    );
  }
}