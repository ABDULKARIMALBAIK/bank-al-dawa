import 'dart:developer';
import 'dart:io';

import 'package:bank_al_dawa/app/core/models/report_models/result_model.dart';
import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/core/widgets/toast.dart';
import 'package:bank_al_dawa/app/core/widgets/widget_state.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/models/app_models/region_model.dart';
import '../../../core/models/report_models/priority_model.dart';
import '../../../core/models/report_models/report_model.dart';
import '../../../core/models/report_models/type_model.dart';
import '../../../core/models/user_models/user_model.dart';
import '../../../core/services/data_list.dart';
import '../../../core/services/request_manager.dart';
import '../shared/constant/dashboard_routes.dart';

class NonDeliveredReportsController extends GetxStorageController
    with GetSingleTickerProviderStateMixin, DataList<Report> {
  DashboardRepository dashboardRepository;

  ScrollController scrollController = ScrollController();
  late AnimationController bottomSheetAnimationController;
  bool isDark = false;
  String isArabic = 'arabic';

  String listReportsId = 'listReportsNonDeliveredId';
  String reportsPaginationId = 'reportsPaginationNonDeliveredId';
  String listEmployeesFilterId = 'listEmployeesFilterId';
  String listResultsFilterId = 'listResultsFilterId';
  String listRegionsFilterId = 'listRegionsFilterId';
  String resultTypeId = 'resultTypeId';
  String listPriorityFilterId = 'listPriorityFilterId';
  String listTypeFilterId = 'listTypeFilterId';
  String listNumberResultsId = 'listNumberResultsId';

  List<RegionModel> regionsFilter = [];
  List<User> usersFilter = [];
  List<PriorityModel> prioritiesFilter = [];
  List<TypeModel> typesFilter = [];
  List<ResultModel> resultsFilter = [];
  int resultTypesSelected = 0;

  List<ResultModel> results = [];
  List<PriorityModel> priorities = [];
  List<TypeModel> types = [];

  TextEditingController userTextField = TextEditingController();
  TextEditingController firstDateTextField = TextEditingController();
  TextEditingController secondDateTextField = TextEditingController();
  String selectedEmployee = '';
  String selectedRegion = '';
  String selectedResults = '';
  String selectedPriority = '';
  String selectedType = '';
  bool releaseReports = false;
  DateTime? selectedDatetime;

  int numberReports = 0;

  @override
  void onInit() async {
    bottomSheetAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    setResults();
    setupPriorities();
    setupTypes();

    loadReports();
    super.onInit();
  }

  NonDeliveredReportsController({required this.dashboardRepository});

  void goRatingReport() => Get.toNamed(
        DashboardRoutes.ratingReportsRoute,
        arguments: [
          {"from_non_delivered_report": true}
        ],
      );

  Future<void> loadReports(
      {RequestType requestType = RequestType.getData,
      bool showLoading = false}) async {
    try {
      if (showLoading) {
        CustomToast.showLoading();
      }

      if (requestType == RequestType.refresh) {
        updateState([listReportsId], WidgetState.loading);
      }

      if (requestType == RequestType.getData) {
        updateState([listReportsId], WidgetState.loading);
      }

      await Future.delayed(const Duration(milliseconds: 500));

      final List<int> regionIds = [];
      final List<int> userIds = [];
      final List<int> resultIds = [];
      final List<int> prioritiesIds = [];
      final List<int> typesIds = [];

      if (regionsFilter.isNotEmpty) {
        for (var tempRegion in regionsFilter) {
          regionIds.add(tempRegion.id);
        }
      }

      if (usersFilter.isNotEmpty) {
        for (var tempUser in usersFilter) {
          userIds.add(tempUser.id);
        }
      }

      if (resultsFilter.isNotEmpty) {
        for (var tempResult in resultsFilter) {
          resultIds.add(tempResult.id);
        }
      }

      if (prioritiesFilter.isNotEmpty) {
        for (var tempPriority in prioritiesFilter) {
          prioritiesIds.add(tempPriority.id);
        }
      }

      if (typesFilter.isNotEmpty) {
        for (var tempType in typesFilter) {
          typesIds.add(tempType.id);
        }
      }

      // final List<Report> finalReports = storageService.reportBox.getAllReports(
      //   page: page,
      //   byEmployeeIds: userIds,
      //   byRegionIds: regionIds,
      //   resultIds: resultIds,
      //   typeIds: typesIds,
      //   priorityIds: prioritiesIds,
      //   byPatientName: userTextField.text,
      //   startDate: firstDateTextField.text.isEmpty
      //       ? null
      //       : DateTime.parse(firstDateTextField.text),
      //   endDate: secondDateTextField.text.isEmpty
      //       ? null
      //       : DateTime.parse(secondDateTextField.text),
      // );

      await handelDataList(
          ids: [reportsPaginationId],
          requestType: requestType,
          function: () async {
            return Future.value(storageService.reportBox.getAllReports(
              page: page,
              byEmployeeIds: userIds,
              byRegionIds: regionIds,
              resultIds: resultIds,
              typeIds: typesIds,
              priorityIds: prioritiesIds,
              byPatientName: userTextField.text,
              startDate: firstDateTextField.text.isEmpty
                  ? null
                  : DateTime.parse(firstDateTextField.text),
              endDate: secondDateTextField.text.isEmpty
                  ? null
                  : DateTime.parse(secondDateTextField.text),
            ));
          });

      numberReports = storageService.reportBox.getNumberReports(
        typeIds: typesIds,
        priorityIds: prioritiesIds,
        byEmployeeIds: userIds,
        byRegionIds: regionIds,
        resultIds: resultIds,
        byPatientName: userTextField.text,
        startDate: firstDateTextField.text.isEmpty
            ? null
            : DateTime.parse(firstDateTextField.text),
        endDate: secondDateTextField.text.isEmpty
            ? null
            : DateTime.parse(secondDateTextField.text),
      );
      updateState([listNumberResultsId], WidgetState.loaded);

      if (showLoading) {
        CustomToast.closeLoading();
      }

      if (numberReports == 0 && dataList.isEmpty) {
        updateState([listReportsId], WidgetState.noResults);
      } else {
        updateState([listReportsId], WidgetState.loaded);
      }
    } on CustomException catch (e) {
      if (requestType != RequestType.loadingMore) {
        updateState([listReportsId], WidgetState.error);
      } else {
        updateState([listReportsId], WidgetState.loaded);
      }

      if (showLoading) {
        CustomToast.closeLoading();
      }
      CustomToast.showError(e.error);
    }
  }

  Future<void> showDatePickerDialog(
      BuildContext context, TextEditingController controller) async {
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
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void setResults() {
    // resultTypes.add(ResultModel(id: 1000, name: 'لا شيء', type: ''));
    results.add(storageService.constantBox.getResults()[0]);

    storageService.constantBox.getResults().forEach((result) {
      if (result.name == 'لم يتم الكشف') {
        results.add(result);
      } else if (result.name == 'حجة') {
        results.add(result);
      } else if (result.name == '+حجة') {
        results.add(result);
      }
    });
  }

  void setupPriorities() {
    priorities.addAll(storageService.constantBox.getPriorities());
  }

  void setupTypes() {
    types.addAll(storageService.constantBox.getTypes());
  }

  void callOperation(String phoneNumber) async {
    log('phone:$phoneNumber');
    await launchUrl(Uri.parse('tel://$phoneNumber'));
  }

  void messageOperation(String phoneNumber) async {
    log('phone:$phoneNumber');
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
}
