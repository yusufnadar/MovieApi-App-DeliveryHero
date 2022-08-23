import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_db/core/constants/colors.dart';
import 'package:movie_db/core/constants/sizes.dart';
import 'package:movie_db/data/controller/movie_controller.dart';
import 'package:movie_db/data/model/movie_detail_model.dart';

class MovieDetailPage extends StatelessWidget {
  final int id;
  final String? posterPath;
  final double voteAverage;
  final String title;

  const MovieDetailPage({
    Key? key,
    required this.id,
    required this.voteAverage,
    required this.title,
    this.posterPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: buildAppBar(),
      body: GetX<MovieController>(
        init: MovieController(),
        initState: (func) {
          func.controller?.movie = MovieDetailModel();
          func.controller?.getMovieDetail(id: id);
        },
        builder: (controller) {
          if (controller.movie.id != null) {
            return Container(
              height: Get.height,
              width: Get.width,
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.02, vertical: Get.height * 0.01),
              decoration: buildBackgroundImage(controller),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [buildMoviePhoto(), buildVoteAverage()],
                  ),
                  Sizes.lowBoxHeight,
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: redColor),
                    child: const Text(
                      'Overview',
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                  Sizes.lowBoxHeight,
                  buildOverview(controller),
                  Sizes.middleBoxHeight,
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: redColor),
                    child: const Text(
                      'Genres',
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                  Sizes.lowBoxHeight,
                  buildGenres(controller)
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Container buildGenres(MovieController controller) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: whiteColor),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.movie.genres!
              .map(
                (e) => Text(
                  e.name! + ', ',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Flexible buildOverview(MovieController controller) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: whiteColor),
        child: Text(
          controller.movie.overview!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Positioned buildVoteAverage() {
    return Positioned(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: whiteColor),
        child: Text(
          voteAverage.toString(),
          style: const TextStyle(fontSize: 18),
        ),
      ),
      bottom: Get.height * 0.02,
      left: Get.width * 0.03,
    );
  }

  ClipRRect buildMoviePhoto() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: posterPath ?? '',
        height: Get.height * 0.4,
        width: Get.width * 0.5,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          // This was the reason for exception being triggered and rendered!
          return Container(
            color: Colors.red,
            height: Get.height * 0.205,
            child: const Center(
              child: Text(
                'No Image',
                style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  BoxDecoration buildBackgroundImage(MovieController controller) {
    return BoxDecoration(
      image: controller.movie.backdropPath != null
          ? DecorationImage(
              image: CachedNetworkImageProvider(
                  'https://image.tmdb.org/t/p/w500${controller.movie.backdropPath}'),
              fit: BoxFit.cover,
              opacity: 0.3,
            )
          : null,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: blackColor),
      ),
      iconTheme: const IconThemeData(color: blackColor),
      backgroundColor: whiteColor,
      elevation: 0,
    );
  }
}
