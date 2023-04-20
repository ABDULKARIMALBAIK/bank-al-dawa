import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bank_al_dawa/app/core/models/report_models/update_report_model.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/constants/urls.dart';
import '../../../core/exceptions/exceptions.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/models/app_models/first_pie_chart_model.dart';
import '../../../core/models/app_models/home_model.dart';
import '../../../core/models/app_models/notification_model.dart';
import '../../../core/models/app_models/second_pie_chart_model.dart';
import '../../../core/models/report_models/report_model.dart';

class DashboardRepository {
  Dio dio;

  DashboardRepository({required this.dio});

  Future<List<NotificationModel>> getNotifications(
      int id, int limit, bool isAdmin) async {
    try {
      final Response response = await dio.get(ConstUrls.notificationsEndPoint,
          queryParameters: {'id': id, 'limit': limit, 'is_admin': isAdmin});
      return NotificationModel.notificationsFromJson(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<Report> getReportDetails(int id) async {
    try {
      final Response response = await dio.get("report/$id");
      return Report.fromMap(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<Response> getReportsDate(String date) async {
    final Response response = await dio.get(
        "${ConstUrls.baseUrl}${ConstUrls.reportDateEndPoint}/$date",
        queryParameters: {
          'date': date,
        });
    return response;
  }

  Future<bool> deleteReport(String id) async {
    try {
      final Response response = await dio.delete(
          "${ConstUrls.baseUrl}${ConstUrls.deleteReportEndPoint}/$id",
          data: {});

      log('response code: ${response.statusCode}');
      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<bool> updateReportState(int id) async {
    try {
      final Response response = await dio.patch(
          "${ConstUrls.baseUrl}${ConstUrls.updateReportStateEndPoint}/$id",
          data: {});

      log('response code: ${response.statusCode}');
      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<Map<String, dynamic>> getAllReports(
      {required Map<String, dynamic> queryParameters}) async {
    try {
      final Response response = await dio.get(ConstUrls.getAllReportsEndPoint,
          queryParameters: queryParameters);
      return {
        'reports': Report.reportList(response.data[0]),
        'number_reports': response.data[1]
      };
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<bool> registerNewReport(
      String name,
      int priorityId,
      int typeId,
      String phone,
      int? regionId,
      String addressDetails,
      int userId,
      String optionalPhone,
      String details) async {
    try {
      final Response response =
          await dio.post(ConstUrls.registerNewReportEndPoint, data: {
        "name": name,
        "priority_id": priorityId,
        "type_id": typeId,
        "phone": phone,
        "region_id": regionId,
        "address_details": addressDetails,
        "user_id": userId,
        "optionalPhone": optionalPhone,
        "details": details,
      });

      log('response code: ${response.statusCode}');
      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<bool> updateReport(
      {required Map<String, dynamic> queryParameter,
      required String reportId}) async {
    try {
      final Response response = await dio.patch(
          '${ConstUrls.baseUrl}${ConstUrls.updateReportEndPoint}/$reportId',
          data: queryParameter);

      log('response code: ${response.statusCode}');
      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<bool> createMeeting(
      String title, String description, String date) async {
    try {
      final Response response = await dio.post(ConstUrls.createMeetingEndPoint,
          data: {"title": title, "description": description, "date": date});

      log('response code: ${response.statusCode}');
      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<bool> reviewReports(int id, String checkAt) async {
    try {
      final Response response =
          await dio.post(ConstUrls.reviewReportEndPoint, data: {
        "id": id,
        "checkAt": checkAt,
      });

      log('response code: ${response.statusCode}');
      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<bool> submitResult(
      {required String details,
      required int resultId,
      required int reportId,
      required String note}) async {
    try {
      final Response response = await dio.post(ConstUrls.submitResultEndPoint,
          data: {
            "details": details,
            "note": note,
            "result_id": resultId,
            "report_id": reportId
          });

      log('response code: ${response.statusCode}');
      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<Report>> getReports() async {
    try {
      final Response response = await dio.get(
          DataHelper.user!.permission!.name == 'مدير' ||
                  DataHelper.user!.permission!.name == 'مشرف'
              ? ConstUrls.downloadReportsEndPoint
              : ConstUrls
                  .downloadReportsEndPoint); //downloadReportsUserEndPoint
      if (response.data["urls"] != null &&
          (response.data["urls"] as List).isNotEmpty) {
        final List urls = response.data["urls"];
        final List<Report> reports = await downloadReports(
            fileUrl: urls[0],
            itemProgress: (progress) {
              log(progress.toString());
            });
        return reports;
      } else {
        throw ExceptionHandler("UnKnowen");
      }
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<Report>> downloadReports({
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

  Future<FirstPieChartModel> loadFirstChartData(
      {required String type, required String date}) async {
    try {
      final Response response = await dio
          .get('${ConstUrls.baseUrl}report-log/statistics/$type/$date');

      return FirstPieChartModel.fromJson(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<SecondPieChartModel> loadSecondChartData(
      {required String type, required String date}) async {
    try {
      final Response response = await dio
          .get('${ConstUrls.baseUrl}report-log/doneStatistics/$type/$date');
      return SecondPieChartModel.fromJson(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<HomeModel> loadHomeData() async {
    try {
      final Response response = await dio.get('home');
      return HomeModel.fromJson(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<UpdateReport> getUpdateReports() async {
    try {
      final Response response =
          await dio.get(ConstUrls.updateDownloadReportEndPoint);
      final UpdateReport updateReport = UpdateReport.fromMap(response.data);
      await _confirmUpdateReports();
      return updateReport;
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

  Future<Map<String, dynamic>> exportExcelReports(
      {required Map<String, dynamic> queryParameters}) async {
    try {
      final Response response = await dio.get('report-log/filter/url',
          queryParameters: queryParameters);

      if (response.data["urls"] != null &&
          (response.data["urls"] as List).isNotEmpty) {
        final List urls = response.data["urls"];
        final Map<String, dynamic> result = await downloadReportsForExcel(
            fileUrl: urls[0],
            itemProgress: (progress) {
              log(progress.toString());
            });
        return result;
      } else {
        throw ExceptionHandler("UnKnowen");
      }
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<Map<String, dynamic>> downloadReportsForExcel({
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

      final List<Report> reports = Report.reportList(reportModelList[0]);
      final int numberReports = reportModelList[1];

      return {'reports': reports, 'number_reports': numberReports};
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> changeRegion(
      {required String regionId,
      required String regionName,
      required String userId}) async {
    try {
      final Map<String, dynamic> data = {
        "regions": [
          {"id": regionId, "name": regionName}
        ]
      };

      // data.removeWhere((key, value) => value == null || value == '');

      final Response response = await dio.patch(
          "${ConstUrls.baseUrl}${ConstUrls.updateAccountEndPoint}/$userId",
          data: data);

      log('response code: ${response.statusCode}');
      return true;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }
}
