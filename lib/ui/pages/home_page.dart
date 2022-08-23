import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_db/core/constants/colors.dart';
import 'package:movie_db/core/constants/sizes.dart';
import 'package:movie_db/data/controller/movie_controller.dart';
import 'package:movie_db/data/model/movie_model.dart';
import 'package:movie_db/ui/pages/movie_detail_page.dart';

class HomePageController extends GetxController {
  final scrollController = ScrollController();

  RxInt page = 1.obs;
  RxString query = ''.obs;
  RxnString lastInput = RxnString();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      page++;
      await Get.find<MovieController>()
          .getMoreMovies(query: query.value, page: page.value);
    }
  }
}

class HomePage extends GetWidget<HomePageController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: GetX<MovieController>(
          init: MovieController(),
          builder: (controller2) => SingleChildScrollView(
            controller: controller.scrollController,
            padding: EdgeInsets.symmetric(
              vertical: Get.height * 0.02,
              horizontal: Get.width * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Sizes.lowBoxHeight,
                buildAppName(),
                Sizes.middleBoxHeight,
                buildSearchInput(controller2),
                Sizes.middleBoxHeight,
                if (controller2.isLoading == false)
                  buildMovieList(controller2)
                else
                  buildIsLoading(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildIsLoading() {
    return SizedBox(
      height: Get.height * 0.7,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  GridView buildMovieList(MovieController controller) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.46,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: controller.movies.length,
      itemBuilder: (context, index) {
        MovieModel oneMovie = controller.movies[index];
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Get.to(
              () => MovieDetailPage(
                  id: oneMovie.id!,
                  title: oneMovie.title!,
                  voteAverage: oneMovie.voteAverage!,
                  posterPath: oneMovie.posterPath != null
                      ? 'http://image.tmdb.org/t/p/w500${oneMovie.posterPath}'
                      : null),
            );
          },
          child: Column(
            children: [
              Stack(
                children: [
                  if (oneMovie.posterPath != null)
                    buildMoviePhoto(oneMovie)
                  else
                    buildNoPhoto(),
                  buildVoteAverage(oneMovie)
                ],
              ),
              Sizes.lowBoxHeight,
              buildMovieTitle(oneMovie),
            ],
          ),
        );
      },
    );
  }

  Expanded buildMovieTitle(MovieModel oneMovie) {
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Text(oneMovie.title ?? ''),
      ),
    );
  }

  Positioned buildVoteAverage(MovieModel oneMovie) {
    return Positioned(
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: whiteColor),
        child: Text(
          oneMovie.voteAverage.toString(),
        ),
      ),
      bottom: Get.height * 0.01,
      left: Get.width * 0.02,
    );
  }

  Container buildNoPhoto() {
    return Container(
      color: Colors.red,
      height: Get.height * 0.205,
      child: const Center(
        child: Text(
          'No Image',
          style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  ClipRRect buildMoviePhoto(MovieModel oneMovie) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: 'https://image.tmdb.org/t/p/w500${oneMovie.posterPath}',
        errorWidget: (context, url, error) {
          return buildNoPhoto();
        },
      ),
    );
  }

  TextFormField buildSearchInput(MovieController controller2) {
    return TextFormField(
      onChanged: (value) async {
        if (controller.lastInput.value != value) {
          controller.lastInput.value = value;
          if (value.length > 2) {
            await controller2.searchMovies(query: value);
            controller.page.value = 1;
            controller.query.value = value;
          }
        }
      },
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Please Search',
        contentPadding: EdgeInsets.symmetric(
          vertical: Get.height * 0.01,
          horizontal: Get.width * 0.04,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Text buildAppName() {
    return const Text(
      'Nadar Movie App',
      style:
          TextStyle(color: redColor, fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
