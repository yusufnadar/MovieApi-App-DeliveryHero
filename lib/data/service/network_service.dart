
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:movie_db/core/constants/end_point.dart';
import 'package:movie_db/core/init/base_model.dart';

class NetworkService {
  static NetworkService? _instance;

  static NetworkService get instance {
    _instance ??= NetworkService._init();
    return _instance!;
  }

  NetworkService._init();

  Future get<T extends BaseModel?>(
      {required String endPoint, required T model}) async {
    var response = await http.get(Uri.parse(EndPoint.baseUrl + endPoint), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == HttpStatus.ok) {
      var data = json.decode(response.body);
      if (model != null) {
        if (data is List) {
          return List<T>.from(data.map((e) => model.fromJson(e)).toList());
        } else if (data is Map<String, dynamic>) {
          return model.fromJson(data);
        } else {
          return null;
        }
      } else {
        return data;
      }
    } else {
      var data = json.decode(response.body);
      Get.snackbar('Hata', data,
          duration: const Duration(seconds: 2));
      return null;
    }
  }
}
