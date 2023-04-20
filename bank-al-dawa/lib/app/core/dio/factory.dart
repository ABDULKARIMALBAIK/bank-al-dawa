import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constants/urls.dart';
import '../services/storage/storage_service.dart';
import 'dio_controller.dart';
import 'request_interceptor.dart';

class DioFactory {
  static Dio dioSetUp() {
    final BaseOptions options = BaseOptions(
      baseUrl: ConstUrls.baseUrl,
      sendTimeout: 20000,
      connectTimeout: 20000,
      receiveTimeout: 40000,
      contentType: "application/json",
    );
    final Dio dio = Dio(options);
    dio.interceptors.addAll([
      RequestInterceptor(
        dioController: DioController(
          dio: dio,
          storageService: Get.find<StorageService>(),
        ),
      ),
    ]);
    return dio;
  }
}
