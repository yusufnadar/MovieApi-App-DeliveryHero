import 'package:get/get.dart';
import 'package:movie_db/core/constants/end_point.dart';
import 'package:movie_db/data/model/movie_detail_model.dart';
import 'package:movie_db/data/model/movie_model.dart';
import 'package:movie_db/data/service/network_service.dart';
import 'package:movie_db/ui/pages/movie_detail_page.dart';

class MovieController extends GetxController {
  final RxList<MovieModel> _movies = RxList<MovieModel>();
  List<MovieModel> get movies => _movies;
  set movies(List<MovieModel> list) => _movies.value = list;

  final Rx<MovieDetailModel> _movie = Rx(MovieDetailModel());
  MovieDetailModel get movie => _movie.value;
  set movie(MovieDetailModel movie)=> _movie.value = movie;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => _isLoading.value = isLoading;

  final RxBool _isLoadingMore = false.obs;
  bool get isLoadingMore => _isLoadingMore.value;
  set isLoadingMore(bool isLoadingMore) => _isLoadingMore.value = isLoadingMore;

  final RxBool _isLoadingDetail = false.obs;
  bool get isLoadingDetail => _isLoadingDetail.value;
  set isLoadingDetail(bool isLoadingDetail) => _isLoadingDetail.value = isLoadingDetail;

  Future<void> searchMovies({String? query,int? page}) async {
    try {
      isLoading = true;
      MainMovieModel mainMovieModel = await NetworkService.instance.get<MainMovieModel>(
        endPoint: EndPoint.search(1, query),
        model: MainMovieModel(),
      );
      movies = <MovieModel>[];
      movies.addAll(mainMovieModel.results!);
    } catch (e) {
      Get.snackbar('Hata', e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<bool>? getMoreMovies({String? query,int? page}) async {
    try {
      isLoadingMore = true;
      MainMovieModel mainMovieModel = await NetworkService.instance.get<MainMovieModel>(
        endPoint: EndPoint.search(page, query),
        model: MainMovieModel(),
      );
      movies.addAll(mainMovieModel.results!);
      return true;
    } catch (e) {
      Get.snackbar('Hata', e.toString());
      return false;
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> getMovieDetail({int? id}) async {
    try {
      isLoadingDetail = true;
      movie  = await NetworkService.instance.get<MovieDetailModel>(
        endPoint: EndPoint.movieDetail(id),
        model: MovieDetailModel(),
      );
    } catch (e) {
      Get.snackbar('Hata', e.toString());
    } finally {
      isLoadingDetail = false;
    }
  }

}
