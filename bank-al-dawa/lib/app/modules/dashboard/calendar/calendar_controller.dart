import 'dart:developer';

import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/models/report_models/report_model.dart';
import '../../../core/services/data_list.dart';
import '../../../core/services/request_manager.dart';
import '../../../core/widgets/toast.dart';
import '../../../core/widgets/widget_state.dart';
import '../shared/constant/dashboard_routes.dart';

class CalendarController extends GetxStorageController
    with GetSingleTickerProviderStateMixin, DataList<Report> {
  DashboardRepository dashboardRepository;

  ScrollController scrollController = ScrollController();
  bool isDark = false;
  String isArabic = 'arabic';

  //Filter sheet variables
  late AnimationController bottomSheetAnimationController;
  DateTime selectedDateTime = DateTime.now();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String buildCalendarItem = 'buildCalendarItem';
  String buildReportsItem = 'buildReportsItem';

  String listDataReportsId = 'listDataReportsId';
  String reportsDataPaginationId = 'reportsDataPaginationId';
  final int limit = 30;

  List<Report> selectedReports = [];
  int selectedReportsNumber = 0;
  String totalSelectedId = 'totalSelectedId';

  @override
  void onInit() async {
    bottomSheetAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    // isDark = await storageService.themeStorage.darkMode();
    // isArabic =
    //     (await storageService.languageStorage.getLanguage()).currentLanguage;

    // Future.delayed(const Duration(milliseconds: 1000))
    //     .then((value) => loadReports());
    loadReports();

    super.onInit();
  }

  CalendarController({required this.dashboardRepository});

  // Future<void> gerReportsDate() async {
  //   try {
  //     updateState([buildReportsItem], WidgetState.loading);
  //
  //     final String currentDate =
  //         DateFormat('yyyy-MM-dd').format(selectedDateTime);
  //     debugPrint('currentDate: $currentDate');
  //     final dio.Response response =
  //         await dashboardRepository.getReportsDate(currentDate);
  //     //reportsDate = meetingsFromJson(response.data);
  //
  //     if (reportsDate.isEmpty) {
  //       updateState([buildReportsItem], WidgetState.noResults);
  //     } else {
  //       updateState([buildReportsItem], WidgetState.loaded);
  //     }
  //   } on CustomException catch (e) {
  //     updateState([buildReportsItem], WidgetState.error);
  //     CustomToast.showError(e.error);
  //   }
  // }

  Future<void> loadReports(
      {RequestType requestType = RequestType.getData}) async {
    try {
      if (requestType == RequestType.getData) {
        updateState([listDataReportsId], WidgetState.loading);
      }

      if (requestType == RequestType.refresh) {
        updateState([listDataReportsId], WidgetState.loading);
      }

      //Create a Map
      final Map<String, dynamic> queryParameters = <String, dynamic>{};
      queryParameters["id"] = requestType == RequestType.refresh ? 0 : lastId;
      queryParameters["limit"] = limit;

      final List<Report> reports = (await dashboardRepository.getAllReports(
          queryParameters: queryParameters))['reports'];

      if (reports.isEmpty && dataList.isEmpty) {
        updateState([listDataReportsId], WidgetState.noResults);
      } else {
        final List<Report> checkAtReports = [];
        final List<Report> nonCheckAtReports = [];

        for (Report report in reports) {
          if (report.checkDate != null) {
            if (DateFormat("yyyy-MM-dd").format(report.checkDate!) ==
                DateFormat("yyyy-MM-dd").format(selectedDateTime)) {
              checkAtReports.add(report);
            }
          } else {
            nonCheckAtReports.add(report);
          }
        }

        selectedReportsNumber = checkAtReports.length;
        Future.delayed(const Duration(milliseconds: 100))
            .then((value) => update([totalSelectedId]));

        //HEREEEEEEEEEEEEEEEEEEEE
        // checkAtReports.addAll(nonCheckAtReports);

        handelDataList(
            ids: [reportsDataPaginationId],
            requestType: requestType,
            function: () async {
              return Future.value(checkAtReports); //reports
            });
        updateState([listDataReportsId], WidgetState.loaded);
      }
    } on CustomException catch (e) {
      updateState([listDataReportsId], WidgetState.error);
      CustomToast.showError(e.error);
    }
  }

  Future<void> createMeeting(BuildContext context) async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      CustomToast.showDefault('calendar_bottom_sheet_toast_fields_empty'.tr);
    } else {
      try {
        CustomToast.showLoading();

        final String currentDate =
            DateFormat('yyyy-MM-dd').format(selectedDateTime);
        debugPrint('currentDate: $currentDate');

        final bool result = await dashboardRepository.createMeeting(
            titleController.text, descriptionController.text, currentDate);

        CustomToast.closeLoading();

        if (result) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          CustomToast.showDefault('تم انشاء موعد لاجتماع بشكل ناجح');
        } else {
          CustomToast.showDefault('العملية فشلت');
        }
      } on CustomException catch (e) {
        CustomToast.showError(e.error);
      }
    }
  }

  Future<void> reviewReports() async {
    if (selectedReports.isEmpty) {
      CustomToast.showDefault('لم نختر أي كشف للمراجعة');
    } else {
      try {
        CustomToast.showLoading();

        for (Report report in selectedReports) {
          final String currentDate =
              DateFormat('yyyy-MM-dd').format(selectedDateTime);
          debugPrint('currentDate: $currentDate');

          final bool result = await dashboardRepository.reviewReports(
              int.parse(report.id.toString()), currentDate);

          if (result) {
            log('passed !!!');
          } else {
            log('Error is Happened');
          }
        }

        //Change State Screen
        selectedReports.clear();
        selectedReportsNumber = 0;
        loadReports(requestType: RequestType.refresh);

        CustomToast.closeLoading();
        CustomToast.showDefault('تم تنفيذ العملية بنجاح');
      } on CustomException catch (e) {
        CustomToast.closeLoading();
        CustomToast.showError(e.error);
      }
    }
  }

  void selectItem(Report report, int index) {
    if (report.checkDate == null) {
      report.isSelected = !report.isSelected;

      if (report.isSelected) {
        selectedReports.add(report);
        selectedReportsNumber++;
      } else {
        selectedReports.remove(report);
        selectedReportsNumber--;
      }

      update([report.id.toString()]);
      update([totalSelectedId]);
    }
  }

  void goRatingReport() => Get.toNamed(
        DashboardRoutes.ratingReportsRoute,
        arguments: [
          //Just fast solution , you can add custom map item for calendar case
          {"from_non_delivered_report": true}
        ],
      );
}
