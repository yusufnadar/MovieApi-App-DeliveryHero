import 'package:get/get.dart';
import 'package:movie_db/data/controller/movie_controller.dart';
import 'package:movie_db/ui/pages/home_page.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomePageController>(HomePageController());
    Get.lazyPut(() => MovieController());
  }
}
