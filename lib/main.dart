import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_db/core/constants/colors.dart';
import 'package:movie_db/core/init/bindings/init_binding.dart';
import 'package:movie_db/ui/pages/home_page.dart';
import 'package:movie_db/ui/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: GetMaterialApp(
        title: 'Nadar Movie App',
        debugShowCheckedModeBanner: false,
        initialBinding: Binding(),
        theme: ThemeData(
          primarySwatch: redColor,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
