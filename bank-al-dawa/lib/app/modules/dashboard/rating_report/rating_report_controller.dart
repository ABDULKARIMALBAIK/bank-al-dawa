import 'dart:developer';
import 'dart:io';

import 'package:bank_al_dawa/app/core/helper/data_helper.dart';
import 'package:bank_al_dawa/app/core/models/report_models/report_log_model.dart';
import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/core/services/quick_sort.dart';
import 'package:bank_al_dawa/app/core/widgets/toast.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/models/report_models/report_model.dart';
import '../../../core/models/report_models/result_model.dart';

class RatingReportController extends GetxStorageController
    with GetSingleTickerProviderStateMixin {
  DashboardRepository dashboardRepository;

  ScrollController scrollController = ScrollController();
  PageController pageControllerType = PageController(initialPage: 0);
  PageController pageControllerComplete = PageController(initialPage: 0);
  int checkStatusSelected = 0;

  TextEditingController reasonController = TextEditingController();
  TextEditingController reasonPlusController = TextEditingController();
  TextEditingController causeController = TextEditingController();
  TextEditingController checkAtDateController = TextEditingController();

  late AnimationController bottomSheetAnimationController;

  String updateTypeResult = 'updateTypeResult';

  String patientName = '';
  String region = '';
  String detailsAddress = '';
  String createReportDate = '';
  String phoneNumber = '';
  String phoneNumberOptional = '';
  String checkDate = '';
  String updateDate = '';
  String type = ''; //اعادة - مساعدة - جديد
  String employeeName = '';
  String noteText = '';
  String resultDate = '';
  String result = '';
  List<ReportLog> reportLogs = [];

  dynamic argumentData = Get.arguments;
  bool isFromNonDeliveredReports = false;

  @override
  void onInit() async {
    bottomSheetAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    //Sync Two PageViews
    pageControllerType.addListener(() {
      pageControllerComplete.animateToPage(
        pageControllerType.page!.toInt(),
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    });

    updateData();

    isFromNonDeliveredReports = argumentData[0]['from_non_delivered_report'];

    super.onInit();
  }

  RatingReportController({required this.dashboardRepository});

  Future<void> updateData() async {
    final Report report = DataHelper.ratingReportModel!;

    checkDate = report.checkDate != null
        ? DateFormat('yyyy-MM-dd').format(report.checkDate!)
        : 'غير محدد';

    updateDate = report.updatedAt != null
        ? DateFormat('yyyy-MM-dd').format(report.updatedAt!)
        : '';

    checkAtDateController.text = report.checkDate == null
        ? ''
        : DateFormat('yyyy-MM-dd').format(report.checkDate!);

    if (report.reportlogs!.isNotEmpty) {
      //report.reportlogs!.length - 1
      if (report.reportlogs![report.reportlogs!.length - 1].result!.name ==
          'حجة') {
        reasonController.text = report.reportlogs!.isEmpty
            ? ''
            : report.reportlogs![report.reportlogs!.length - 1].details;
      }

      if (report.reportlogs![report.reportlogs!.length - 1].result!.name ==
          '+حجة') {
        reasonPlusController.text = report.reportlogs!.isEmpty
            ? ''
            : report.reportlogs![report.reportlogs!.length - 1].details;
      }

      //New
      causeController.text =
          report.reportlogs![report.reportlogs!.length - 1].note;
    }

    patientName = report.name;
    region = report.region == null ? 'غير محدد' : report.region!.name;
    detailsAddress =
        report.addressDetails == null ? 'غير محدد' : report.addressDetails!;
    createReportDate = DateFormat('yyyy-MM-dd').format(report.createdAt);
    phoneNumber = report.phone;

    // report.report!.checkDate ?? ''
    //     : 'لم تتم الزيارة'; //DateFormat('yyyy-MM-dd').format(report.report!.visitDate!)   //visitDate
    type = report.type!.name;
    employeeName = report.shortUser!.name;

    // ignore: unnecessary_null_comparison
    resultDate = report.reportlogs!.isEmpty
        ? 'لم يتم الكشف'
        // ignore: unnecessary_null_comparison
        : report.reportlogs![report.reportlogs!.length - 1].date != null
            ? DateFormat('yyyy-MM-dd')
                .format(report.reportlogs![report.reportlogs!.length - 1].date)
            : 'لم يتم الكشف';
    result = report.reportlogs!.isEmpty
        ? 'غير محدد'
        : report.reportlogs![report.reportlogs!.length - 1].result != null
            ? report.reportlogs![report.reportlogs!.length - 1].result!.type
            : 'غير محدد';

    noteText = report.details;
    phoneNumberOptional = report.optionalPhone;

    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (report.reportlogs!.isNotEmpty) {
        switch (
            report.reportlogs![report.reportlogs!.length - 1].result!.name) {
          case "لم يتم الكشف":
            {
              pageControllerType.animateToPage(0,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);
              pageControllerComplete.animateToPage(0,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);
              break;
            }
          case "تم":
            {
              pageControllerType.animateToPage(1,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);
              pageControllerComplete.animateToPage(1,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);

              // ignore: unrelated_type_equality_checks
              if (report.reportlogs![report.reportlogs!.length - 1].result!.type
                      .trim() ==
                  'A') {
                checkStatusSelected = 0;
              }
              // ignore: unrelated_type_equality_checks
              else if (report
                      .reportlogs![report.reportlogs!.length - 1].result!.type
                      .trim() ==
                  'B') {
                checkStatusSelected = 1;
              }
              // ignore: unrelated_type_equality_checks
              else if (report
                      .reportlogs![report.reportlogs!.length - 1].result!.type
                      .trim() ==
                  'C') {
                checkStatusSelected = 2;
              }
              // ignore: unrelated_type_equality_checks
              // else if (report
              //         .reportlogs![report.reportlogs!.length - 1].result!.type
              //         .trim() ==
              //     'D') {
              //   checkStatusSelected = 3;
              // }
              // ignore: unrelated_type_equality_checks
              else if (report
                      .reportlogs![report.reportlogs!.length - 1].result!.type
                      .trim() ==
                  'X') {
                checkStatusSelected = 3;
              } else if (report
                      .reportlogs![report.reportlogs!.length - 1].result!.type
                      .trim() ==
                  'تم') {
                checkStatusSelected = 4;
              }

              break;
            }
          case "حجة":
            {
              pageControllerType.animateToPage(2,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);
              pageControllerComplete.animateToPage(2,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);

              break;
            }
          case "+حجة":
            {
              pageControllerType.animateToPage(3,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);
              pageControllerComplete.animateToPage(3,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);

              break;
            }
        }
      }
    });

    //Old Ratings list
    if (report.reportlogs != null) {
      if (report.reportlogs!.isNotEmpty) {
        // final tempReports = report.reportlogs!;
        final List<ReportLog> tempReports = await QuickSort.sort(
            list: report.reportlogs!,
            low: 0,
            high: report.reportlogs!.length - 1);
        reportLogs = tempReports.reversed.toList();
        log('list_${reportLogs.length}');
      }
    }

    //Update Entire Screen
    update(['updateTypeResult']);
    update();
  }

  Future<void> submitResult() async {
    if (isFromNonDeliveredReports) {
      CustomToast.showDefault('لا يمكنك التقييم حالياً');
    } else {
      if (pageControllerType.page! >= 0 && pageControllerType.page! < 1) {
        // CustomToast.showDefault('من فضلك اختر تم الكشف أو حجة أو حجة+');

        final ResultModel resultModel = DataHelper.results[DataHelper.results
            .indexWhere((result) => result.name == 'لم يتم الكشف')];
        final ResultModel result = ResultModel(
            id: resultModel.id, name: resultModel.name, type: resultModel.type);

        await startSubmitResult(' ', result, DataHelper.ratingReportModel!.id);
      } else if (pageControllerType.page! >= 1 &&
          pageControllerType.page! < 2) {
        if (checkAtDateController.text.isEmpty && checkStatusSelected != 3) {
          CustomToast.showDefault('من فضلك اضف موعد قدوم المريض');
        } else {
          final ResultModel? resultModel = getResultsWhenUpdate();

          //New
          if (resultModel!.type.trim() == 'X') {
            if (checkAtDateController.text.isNotEmpty) {
              CustomToast.showDefault('يجب عدم تحديد موعد قدوم المريض');
              return;
            }
          }

          final ResultModel result = ResultModel(
              id: resultModel.id,
              name: resultModel.name,
              type: resultModel.type);

          await startSubmitResult(
              ' ', result, DataHelper.ratingReportModel!.id);

          if (checkStatusSelected != 3) {
            await reviewReport(DataHelper.ratingReportModel!.id.toString(),
                checkAtDateController.text);
          }
        }
      } else if (pageControllerType.page! >= 2 &&
          pageControllerType.page! < 3) {
        if (reasonController.text.isEmpty) {
          CustomToast.showDefault('من فضلك ادخل سبب الحجة');
        } else {
          final ResultModel resultModel = DataHelper.results[
              DataHelper.results.indexWhere((result) => result.name == 'حجة')];
          final ResultModel result = ResultModel(
              id: resultModel.id,
              name: resultModel.name,
              type: resultModel.type);

          await startSubmitResult(
              reasonController.text, result, DataHelper.ratingReportModel!.id);
        }
      } else if (pageControllerType.page! >= 3 &&
          pageControllerType.page! < 4) {
        if (reasonPlusController.text.isEmpty) {
          CustomToast.showDefault('من فضلك ادخل سبب الحجة+');
        } else {
          final ResultModel resultModel = DataHelper.results[
              DataHelper.results.indexWhere((result) => result.name == '+حجة')];
          final ResultModel result = ResultModel(
              id: resultModel.id,
              name: resultModel.name,
              type: resultModel.type);

          await startSubmitResult(reasonPlusController.text, result,
              DataHelper.ratingReportModel!.id);
        }
      }
    }
  }

  ResultModel? getResultsWhenUpdate() {
    ResultModel? resultData;

    if (checkStatusSelected == 0) {
      for (var result in DataHelper.results) {
        if (result.type.trim() == 'A') {
          resultData = result;
        }
      }
      return resultData;
    } else if (checkStatusSelected == 1) {
      for (var result in DataHelper.results) {
        if (result.type.trim() == 'B') {
          resultData = result;
        }
      }
      return resultData;
    } else if (checkStatusSelected == 2) {
      for (var result in DataHelper.results) {
        if (result.type.trim() == 'C') {
          resultData = result;
        }
      }
      return resultData;
    }
    // else if (checkStatusSelected == 3) {
    //   for (var result in DataHelper.results) {
    //     if (result.type.trim() == 'D') {
    //       resultData = result;
    //     }
    //   }
    //   return resultData;
    // }
    else if (checkStatusSelected == 3) {
      for (var result in DataHelper.results) {
        if (result.type.trim() == 'X') {
          resultData = result;
        }
      }
      return resultData;
    } else if (checkStatusSelected == 4) {
      for (var result in DataHelper.results) {
        if (result.type.trim() == 'تم') {
          resultData = result;
        }
      }
      return resultData;
    } else {
      return resultData;
    }
  }

  Future<void> startSubmitResult(
      String details, ResultModel result, int reportId) async {
    try {
      CustomToast.showLoading();

      final bool resultResponse = await dashboardRepository.submitResult(
          details: details,
          reportId: reportId,
          resultId: result.id,
          note: causeController.text);

      if (resultResponse) {
        CustomToast.closeLoading();

        //NEW
        if (result.name == 'لم يتم الكشف') {
          DataHelper.ratingReportModel!.patientIsCame = false;
          DataHelper.ratingReportModel!.userIsReceived = false;
        }

        if (DataHelper.ratingReportModel!.reportlogs!.isEmpty) {
          DataHelper.ratingReportModel!.reportlogs = [];
        }

        DataHelper.ratingReportModel!.reportlogs!.add(ReportLog(
          id: reportLogs.isEmpty
              ? 1
              : reportLogs[0].id + 1, //int.parse(response.data["id"])
          date: DateTime.now(), //DateTime.parse(response.data["date"])
          details: details,
          note: causeController.text,
          shortUser: DataHelper.ratingReportModel!.shortUser!,
          result: result,
          report: DataHelper.ratingReportModel!,
        ));

        Get.back(result: [
          {'isUpdated': true}
        ]);

        CustomToast.showDefault('تم تقييم الكشف بنجاح');
      } else {
        CustomToast.closeLoading();
        CustomToast.showDefault('Wrong thing is happened');
      }
    } on CustomException catch (e) {
      CustomToast.closeLoading();
      CustomToast.showError(e.error);
    }
  }

  Future<void> reviewReport(String reportId, String currentDate) async {
    try {
      // CustomToast.showLoading();

      log('currentDate_$currentDate');
      final bool result = await dashboardRepository.reviewReports(
          int.parse(reportId), currentDate);

      if (result) {
        log('reviewed');

        DataHelper.ratingReportModel!.checkDate =
            DateTime.parse(checkAtDateController.text);
      } else {
        log('Error is Happened');
      }

      // CustomToast.closeLoading();
      // CustomToast.showDefault('تم اضافة تاريخ قدوم المريض بنجاح');
    } on CustomException catch (e) {
      // CustomToast.closeLoading();
      CustomToast.showError(e.error);
    }
  }

  void callOperation(String phoneNumber) async {
    await launchUrl(Uri.parse('tel://$phoneNumber'));
  }

  void messageOperation(String phoneNumber) async {
    String url = '';
    if (Platform.isAndroid) {
      //FOR Android
      url = 'sms:$phoneNumber?body=ارسل_رسالة';
    } else if (Platform.isIOS) {
      //FOR IOS
      url = 'sms:$phoneNumber&body=ارسل_رسالة';
    }

    await launchUrl(Uri.parse(url));
  }

  Future<void> showDatePickerDialog(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale('en'),
        initialDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2005),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                    primary: Theme.of(context).primaryColor,
                    onPrimary: Colors.white,
                    onSurface: Theme.of(context).primaryColor),
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor))),
            child: child!,
          );
        });

    if (picked != null) {
      checkAtDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }
}
