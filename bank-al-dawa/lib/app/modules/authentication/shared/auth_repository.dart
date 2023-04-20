import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bank_al_dawa/app/core/exceptions/exceptions.dart';
import 'package:bank_al_dawa/app/core/models/app_models/constant_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/report_model.dart';
import 'package:bank_al_dawa/app/core/models/user_models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/constants/urls.dart';

class AuthRepository {
  final Dio dio;

  AuthRepository({required this.dio});

  Future<bool> transferReports(
      {required int oldUser,
      required int newUser,
      required String regionId}) async {
    try {
      final Map<String, dynamic> parameters = {
        "oldId": oldUser,
        "newId": newUser,
      };

      if (regionId.isNotEmpty) {
        parameters['regionId'] = int.parse(regionId);
      }

      final Response response = await dio.patch(
          "${ConstUrls.baseUrl}report/user",
          queryParameters: parameters,
          data: {});

      log('register_response_code: ${response.statusCode}');

      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<User> loginUser({
    required String username,
    required String password,
    required String fcmToken,
  }) async {
    try {
      final Response response = await dio.post(ConstUrls.loginEndPoint, data: {
        "name": username,
        "password": password,
        "fcmToken": fcmToken,
      });
      return User.appUserfromJson(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<bool> registerUser(String username, String password, String urlImage,
      String phone, List? regions, int permissionId) async {
    try {
      final Response response =
          await dio.post(ConstUrls.registerEndPoint, data: {
        "name": username,
        "password": password,
        "image_url": urlImage,
        "phone": phone,
        "permission_id": permissionId,
        "regions": regions,
      });

      log('register_response_code: ${response.statusCode}');

      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<bool> updateAccountData(
      String id,
      String username,
      String password,
      // String fcmToken,
      String urlImage,
      String phone,
      List? regions,
      int permissionId) async {
    try {
      final Map<String, dynamic> data = {
        "name": username,
        "password": password,
        // "fcm_token": fcmToken,
        "image_url": urlImage,
        "phone": phone,
        "permission_id": permissionId,
        "regions": regions,
      };

      data.removeWhere((key, value) => value == null || value == '');

      final Response response = await dio.patch(
          "${ConstUrls.baseUrl}${ConstUrls.updateAccountEndPoint}/$id",
          data: data);

      log('response code: ${response.statusCode}');
      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<dynamic> uploadImage(String path, String name) async {
    try {
      final FormData formData = FormData.fromMap(
          {'image': await MultipartFile.fromFile(path, filename: name)});

      final Response response =
          await dio.post(ConstUrls.uploadFileUrl, data: formData);

      return response.data["urls"][0];
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<ConstantModel> getConstants() async {
    try {
      final Response response = await dio.get(ConstUrls.constantEndPoint);
      return ConstantModel.fromMap(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<Report>> getReports() async {
    try {
      final Response response =
          await dio.get(ConstUrls.downloadReportsEndPoint);

      if (response.data != null) {
        if (response.data["urls"] != null &&
            (response.data["urls"] as List).isNotEmpty) {
          final List urls = response.data["urls"];
          final List<Report> reports = await _downloadReports(
              fileUrl: urls[0],
              itemProgress: (progress) {
                log('progress_${progress.toString()}');
              });
          await _confirmUpdateReports();
          return reports;
        } else {
          throw ExceptionHandler("UnKnowen");
        }
      } else {
        return [];
      }
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> _confirmUpdateReports() async {
    try {
      await dio.patch(ConstUrls.updateDownloadReportEndPoint, data: {});
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Report>> _downloadReports({
    required String fileUrl,
    required Function(int progress) itemProgress,
  }) async {
    try {
      int fakeCounter = 0;

      final Response result = await dio.get(
        fileUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
        onReceiveProgress: (received, total) {
          int progress = (received / total * 100).toInt();
          fakeCounter = fakeCounter > 100 ? 100 : fakeCounter++;
          progress = progress > 100
              ? 100
              : progress < 0
                  ? fakeCounter
                  : progress;
          itemProgress(progress);
        },
      );
      final Directory tempDir = await getTemporaryDirectory();
      final String fullPath = "${tempDir.path}/reports.txt";
      final File file = File(fullPath);
      final RandomAccessFile raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(result.data);
      await raf.close();
      final String contents = await file.readAsString();
      final List reportModelList = jsonDecode(contents);
      return Report.reportList(reportModelList);
    } catch (error) {
      rethrow;
    }
  }
}
