import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_db/core/constants/images.dart';
import 'package:movie_db/ui/pages/home_page.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2)).then(
      (value) => Get.to(() => const HomePage()),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());
    return Scaffold(
      body: buildLogo(),
    );
  }

  Center buildLogo() {
    return Center(
      child: Image.asset(
        logo,
        width: Get.width * 0.5,
      ),
    );
  }
}
