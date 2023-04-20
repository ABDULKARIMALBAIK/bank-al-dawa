import 'package:bank_al_dawa/app/core/constants/urls.dart';
import 'package:dio/dio.dart';

import '../constants/request_routes.dart';
import '../helper/data_helper.dart';
import '../services/storage/storage_service.dart';

class DioController {
  final Dio dio;
  final StorageService storageService;

  DioController({
    required this.dio,
    required this.storageService,
  });

  Future<String> checkToken({
    required String url,
    bool shouldRefresh = false,
  }) async {
    if (urlWithoutToken.contains(url) || DataHelper.user == null) {
      return '';
    } else {
      if (shouldRefresh ||
          DateTime.now().isAfter(DataHelper.user!.accessTokenExpiryDate)) {
        try {
          final Response result = await refreshToken();

          DataHelper.user!.accessToken = result.data['accessToken'];
          DataHelper.user!.accessTokenExpiryDate =
              DateTime.now().add(Duration(seconds: result.data['expireTime']));
          storageService.userBox.setUser(DataHelper.user!);
          return result.data['accessToken'];
        } on DioError {
          return '';
        }
      } else {
        return DataHelper.user!.accessToken;
      }
    }
  }

  Future<Response> refreshToken() async {
    try {
      final result = await dio.patch(RequestRoutes.refreshToken,
          data: {"refreshToken": DataHelper.user!.refreshToken});
      return result;
    } catch (e) {
      rethrow;
    }
  }

  List<String> urlWithoutToken = [
    RequestRoutes.refreshToken,
    ConstUrls.loginEndPoint,
  ];
}
