import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:bank_al_dawa/app/core/helper/data_helper.dart';
import 'package:bank_al_dawa/app/core/models/app_models/region_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/priority_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/report_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/type_model.dart';
import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/constant/dashboard_routes.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:device_info/device_info.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/models/report_models/result_model.dart';
import '../../../core/models/user_models/user_model.dart';
import '../../../core/services/data_list.dart';
import '../../../core/services/request_manager.dart';
import '../../../core/widgets/toast.dart';
import '../../../core/widgets/widget_state.dart';

class AllReportsController extends GetxStorageController
    with GetSingleTickerProviderStateMixin, DataList<Report> {
  DashboardRepository dashboardRepository;

  ScrollController scrollController = ScrollController();
  bool isDark = false;
  String isArabic = 'arabic';

  //Filter sheet variables
  late AnimationController bottomSheetAnimationController;
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

  String listReportsId = 'listReportsId';
  String listNumberResults = 'listNumberResults';
  String reportsPaginationId = 'reportsPaginationId';
  String listEmployeesFilterId = 'listEmployeesFilterId';
  String listResultsFilterId = 'listResultsFilterId';
  String listRegionsFilterId = 'listRegionsFilterId';
  String listPriorityFilterId = 'listPriorityFilterId';
  String listTypeFilterId = 'listTypeFilterId';
  String resultTypeId = 'resultTypeId';
  final int limit = 30;

  List<RegionModel> regionsFilter = [];
  List<User> usersFilter = [];
  List<ResultModel> resultsFilter = [];
  List<PriorityModel> prioritiesFilter = [];
  List<TypeModel> typesFilter = [];
  int resultTypesSelected = 0;

  List<ResultModel> results = [];
  List<PriorityModel> priorities = [];
  List<TypeModel> types = [];
  int numberReports = 0;

  @override
  void onInit() async {
    bottomSheetAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    setupResults();
    setupPriorities();
    setupTypes();

    // isDark = await storageService.themeStorage.darkMode();
    // isArabic =
    //     (await storageService.languageStorage.getLanguage()).currentLanguage;

    // Future.delayed(const Duration(milliseconds: 1000))
    //     .then((value) => loadReports());
    loadReports();

    super.onInit();
  }

  AllReportsController({required this.dashboardRepository});

  void goRatingReport() => Get.toNamed(
        DashboardRoutes.ratingReportsRoute,
        arguments: [
          {"from_non_delivered_report": false}
        ],
      )?.then((result) {
        if (result != null) {
          if (result[0]['isUpdated'] == true) {
            dataList[dataList.indexWhere((report) =>
                    report.id == DataHelper.ratingReportModel!.id)] =
                DataHelper.ratingReportModel!;
            updateState([listReportsId], WidgetState.loaded);
          }
        }
      });

  void goRegisterReport(bool isEdit) => Get.toNamed(
        DashboardRoutes.registerReportRoute,
        arguments: [
          {"from_non_home": isEdit}
        ],
      )?.then((result) {
        if (result != null) {
          if (result[0]['isUpdated'] == true) {
            // report.id == DataHelper.reportModel!.id
            // dataList[dataList.indexWhere(
            //         (report) => report.id == DataHelper.reportModel!.id)] = DataHelper.reportModel!;

            for (int i = 0; i < dataList.length; i++) {
              if (dataList[i].name == DataHelper.reportModel!.name) {
                dataList[i] = DataHelper.reportModel!;
              }
            }

            updateState([listReportsId], WidgetState.loaded);
          }

          if (result[0]['isCreated'] == true) {
            loadReports(requestType: RequestType.refresh);
          }
        }
      });

  // void filterResults() {
  //   final List<ReportLog> filteredList = [];

//     for (var report in dataList) {
//       if (userTextField.text.isNotEmpty) {
//         if (!report.report!.name.contains(userTextField.text)) {
//           continue;
//         }
//       }
//       if (selectedEmployee.isNotEmpty) {
//         if (!report.shortUser!.name.contains(selectedEmployee)) {
//           continue;
//         }
//       }
//       if (selectedRegion.isNotEmpty) {
//         if (!report.report!.region!.name.contains(sdRegion)) {
//           continue;
//         }
//       }
//       if (releaseReports) {
//         final String result = report.result!.name ?? '';
//         if (!(result.contains('تم') ||
//             result.contains('حجة') ||
//             result.contains('حجة+'))) {
//           continue;
//         }
//       }
//  f (selatetime != null) {
//         if (!(DateFormat('yyyy-MM-dd').format(selectedDatetime!) ==
//             DateFormat('yyyy-MM-dd').format(report.report!.createdAt))) {
//           continue;
//         }
//       }

//       filteredList.add(report);
//     }
//     handelDataList(
//         ids: [reportsPaginationId],
//         requestType: RequestType.refresh,
//         function: () async {
//           return Future.value(filteredList);
//         });
//     updateState([listReportsId], WidgetState.loaded);
//   }

  Future<void> loadReports(
      {RequestType requestType = RequestType.getData,
      bool showLoading = false}) async {
    try {
      if (secondDateTextField.text.isNotEmpty &&
          firstDateTextField.text.isEmpty) {
        Future.delayed(const Duration(milliseconds: 300)).then(
            (value) => CustomToast.showDefault('ادخل تاريخ البداية من فضلك'));
        return;
      }

      if (showLoading) {
        CustomToast.showLoading();
      }

      if (requestType == RequestType.refresh) {
        updateState([listReportsId], WidgetState.loading);
      }

      if (requestType == RequestType.getData) {
        updateState([listReportsId], WidgetState.loading);
      }

      //Create a Map
      final Map<String, dynamic> queryParameters = <String, dynamic>{};
      queryParameters["id"] = requestType == RequestType.refresh ? 0 : lastId;
      queryParameters["limit"] = limit;

      //Check Filters
      if (userTextField.text.isNotEmpty) {
        queryParameters["name"] = userTextField.text;
      }

      if (regionsFilter.isNotEmpty) {
        final List<int> regionIds = [];
        for (var tempRegion in regionsFilter) {
          regionIds.add(tempRegion.id);
        }
        queryParameters["regions"] = regionIds;
      }

      if (usersFilter.isNotEmpty) {
        final List<int> userIds = [];
        for (var tempUser in usersFilter) {
          userIds.add(tempUser.id);
        }
        queryParameters["users"] = userIds;
      }

      if (resultsFilter.isNotEmpty) {
        final List<int> resultIds = [];
        for (var tempResult in resultsFilter) {
          resultIds.add(tempResult.id);
        }
        queryParameters["results"] = resultIds;
      }

      if (prioritiesFilter.isNotEmpty) {
        final List<int> priorityIds = [];
        for (var tempPriority in prioritiesFilter) {
          priorityIds.add(tempPriority.id);
        }
        queryParameters["priorities"] = priorityIds;
      }

      if (typesFilter.isNotEmpty) {
        final List<int> typeIds = [];
        for (var tempType in typesFilter) {
          typeIds.add(tempType.id);
        }
        queryParameters["types"] = typeIds;
      }

      if (firstDateTextField.text.isNotEmpty) {
        queryParameters["startDate"] = firstDateTextField.text;
      }

      if (secondDateTextField.text.isNotEmpty) {
        queryParameters["endDate"] = secondDateTextField.text;
      }

      final Map<String, dynamic> result = await dashboardRepository
          .getAllReports(queryParameters: queryParameters);

      final List<Report> reports = result['reports'];

      //Update number of reports
      if (requestType != RequestType.loadingMore) {
        numberReports = result['number_reports'];
      }

      await handelDataList(
          ids: [reportsPaginationId],
          requestType: requestType,
          function: () async {
            return Future.value(reports);
          });

      if (showLoading) {
        CustomToast.closeLoading();
      }

      if (reports.isEmpty && dataList.isEmpty) {
        updateState([listReportsId], WidgetState.noResults);
        updateState([listNumberResults], WidgetState.loaded);
      } else {
        updateState([listReportsId], WidgetState.loaded);
        updateState([listNumberResults], WidgetState.loaded);
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

  bool isUsingFilters() {
    if (userTextField.text.isNotEmpty ||
        regionsFilter.isNotEmpty ||
        usersFilter.isNotEmpty ||
        resultsFilter.isNotEmpty ||
        firstDateTextField.text.isNotEmpty ||
        secondDateTextField.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateReportState(Report reportResponse) async {
    try {
      CustomToast.showLoading();

      final bool result = await dashboardRepository
          .updateReportState(int.parse(reportResponse.id.toString()));

      CustomToast.closeLoading();

      if (result) {
        if (reportResponse.userIsReceived == false) {
          reportResponse.userIsReceived = true;
          reportResponse.patientIsCame = false;
        } else {
          reportResponse.userIsReceived = true;
          reportResponse.patientIsCame = true;
        }

        //  dataList[dataList.indexWhere(
        //     (report) => report.id == reportResponse.id)] = reportResponse;

        for (int i = 0; i < dataList.length; i++) {
          if (dataList[i].id == reportResponse.id) {
            dataList[i] = reportResponse;
          }
        }
        updateState([listReportsId], WidgetState.loaded);
      } else {
        CustomToast.showDefault('حدث خطأ');
      }
    } on CustomException catch (e) {
      CustomToast.closeLoading();
      // updateState([listReportsId], WidgetState.error);
      CustomToast.showError(e.error);
    }
  }

  Future<void> deleteReport(Report reportResponse) async {
    try {
      CustomToast.showLoading();

      final bool result =
          await dashboardRepository.deleteReport(reportResponse.id.toString());
      if (result) {
        dataList.remove(reportResponse);
        updateState([listReportsId], WidgetState.loaded);

        CustomToast.closeLoading();
        Future.delayed(const Duration(milliseconds: 200))
            .then((value) => CustomToast.showDefault('تم حذف الكشف بنجاح'));

        numberReports--;
        updateState([listNumberResults], WidgetState.loaded);
      } else {
        CustomToast.closeLoading();
        CustomToast.showDefault('Wrong thing is happened');
      }
    } on CustomException catch (e) {
      // updateState([listReportsId], WidgetState.error);
      Future.delayed(const Duration(milliseconds: 200))
          .then((value) => CustomToast.showError(e.error));
    }
  }

  void callOperation(String phoneNumber) async {
    developer.log('phone:$phoneNumber');
    await launchUrl(Uri.parse('tel://$phoneNumber'));
  }

  void messageOperation(String phoneNumber) async {
    developer.log('phone:$phoneNumber');
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

  void setupResults() {
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

  Future<void> makeExcelFile() async {
    try {
      if ((await Permission.storage.isDenied) ||
          (await Permission.manageExternalStorage.isDenied)) {
        final List<Permission> permissions = [
          Permission.storage,
          Permission.manageExternalStorage
        ];

        int sdkInt = 0;
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          sdkInt = androidInfo.version.sdkInt;
          if (sdkInt < 30) {
            permissions.removeAt(1);
          }
        }
        await permissions.request().then((permissionStatus) {
          if (permissionStatus[Permission.storage] ==
              PermissionStatus.granted) {
            if (sdkInt >= 30) {
              if (permissionStatus[Permission.manageExternalStorage] ==
                  PermissionStatus.granted) {
                startCreateExcelFile();
              } else {
                CustomToast.showDefault('لا يمكنك تصدير ملف الاكسيل');
                CustomToast.closeLoading();
              }
            } else {
              startCreateExcelFile();
            }
          } else {
            CustomToast.showDefault('لا يمكنك تصدير ملف الاكسيل');
            CustomToast.closeLoading();
          }
        });
      } else {
        startCreateExcelFile();
      }
    } catch (e) {
      developer.log('error_excel: $e');
    }
  }

  void startCreateExcelFile() async {
    try {
      //Create a Map
      final Map<String, dynamic> queryParameters = <String, dynamic>{};

      //Check Filters
      if (userTextField.text.isNotEmpty) {
        queryParameters["name"] = userTextField.text;
      }

      if (regionsFilter.isNotEmpty) {
        final List<int> regionIds = [];
        for (var tempRegion in regionsFilter) {
          regionIds.add(tempRegion.id);
        }
        queryParameters["regions"] = regionIds;
      }

      if (usersFilter.isNotEmpty) {
        final List<int> userIds = [];
        for (var tempUser in usersFilter) {
          userIds.add(tempUser.id);
        }
        queryParameters["users"] = userIds;
      }

      if (resultsFilter.isNotEmpty) {
        final List<int> resultIds = [];
        for (var tempResult in resultsFilter) {
          resultIds.add(tempResult.id);
        }
        queryParameters["results"] = resultIds;
      }

      if (prioritiesFilter.isNotEmpty) {
        final List<int> priorityIds = [];
        for (var tempPriority in prioritiesFilter) {
          priorityIds.add(tempPriority.id);
        }
        queryParameters["priorities"] = priorityIds;
      }

      if (typesFilter.isNotEmpty) {
        final List<int> typeIds = [];
        for (var tempType in typesFilter) {
          typeIds.add(tempType.id);
        }
        queryParameters["types"] = typeIds;
      }

      if (firstDateTextField.text.isNotEmpty) {
        queryParameters["startDate"] = firstDateTextField.text;
      }

      if (secondDateTextField.text.isNotEmpty) {
        queryParameters["endDate"] = secondDateTextField.text;
      }

      final Map<String, dynamic> result = await dashboardRepository
          .exportExcelReports(queryParameters: queryParameters);

      final List<Report> reports = result['reports'];
      final int numberReportsValue = result['number_reports'];

      //Check if data is empty
      if (reports.isNotEmpty) {
        //Create excel File and make new sheet
        final String sheetName = 'التقارير${Random().nextInt(1000)}';
        final excel = Excel.createExcel();
        excel.rename('Sheet1', sheetName);
        final Sheet sheetObject = excel[sheetName];

        //Make Names for Columns
        final cellName = sheetObject.cell(CellIndex.indexByString("A1"));
        cellName.value = 'اسم المريض';
        final cellPhone = sheetObject.cell(CellIndex.indexByString("B1"));
        cellPhone.value = 'رقم الهاتف';
        final cellPhoneOptional =
            sheetObject.cell(CellIndex.indexByString("C1"));
        cellPhoneOptional.value = 'رقم الهاتف الاضافي';
        final cellRegionName = sheetObject.cell(CellIndex.indexByString("D1"));
        cellRegionName.value = 'العنوان';
        final cellAddressDetails =
            sheetObject.cell(CellIndex.indexByString("E1"));
        cellAddressDetails.value = 'العنوان التفصيلي';

        //Make Names for Columns
        // final cellName = sheetObject.cell(CellIndex.indexByString("A1"));
        // cellName.value = 'اسم المريض';
        // final cellPhone = sheetObject.cell(CellIndex.indexByString("B1"));
        // cellPhone.value = 'رقم الهاتف';
        // final cellAddressDetails =
        //     sheetObject.cell(CellIndex.indexByString("C1"));
        // cellAddressDetails.value = 'العنوان التفصيلي';
        // final cellCheckDate = sheetObject.cell(CellIndex.indexByString("D1"));
        // cellCheckDate.value = 'تاريخ قدوم المريض';
        // final cellUserIsReceived =
        //     sheetObject.cell(CellIndex.indexByString("E1"));
        // cellUserIsReceived.value = 'الموظف راجع الكشف';
        // final cellPatientIsCame =
        //     sheetObject.cell(CellIndex.indexByString("F1"));
        // cellPatientIsCame.value = 'المريض قد وصل';
        // final cellEmployeeName =
        //     sheetObject.cell(CellIndex.indexByString("G1"));
        // cellEmployeeName.value = 'اسم الموظف';
        // final cellRegionName = sheetObject.cell(CellIndex.indexByString("H1"));
        // cellRegionName.value = 'اسم المنطقة';
        // final cellPriority = sheetObject.cell(CellIndex.indexByString("I1"));
        // cellPriority.value = 'الأولوية';
        // final cellLastLogName = sheetObject.cell(CellIndex.indexByString("J1"));
        // cellLastLogName.value = 'اسم آخر كشف';
        // final cellLastLogType = sheetObject.cell(CellIndex.indexByString("K1"));
        // cellLastLogType.value = 'نوع آخر كشف';
        // final cellLastLogDetails =
        //     sheetObject.cell(CellIndex.indexByString("L1"));
        // cellLastLogDetails.value = 'تفاصيل آخر كشف';
        // final cellLastLogDate = sheetObject.cell(CellIndex.indexByString("M1"));
        // cellLastLogDate.value = 'تاريخ آخر كشف';
        // final cellNumberReports =
        //     sheetObject.cell(CellIndex.indexByString("N1"));
        // cellNumberReports.value = 'عدد الكشوفات';

        // final cellNumberReportsValue =
        //     sheetObject.cell(CellIndex.indexByString("N2"));
        // cellNumberReportsValue.value = numberReportsValue;

        //Fill Data
        for (int i = 0; i < reports.length; i++) {
          final cellName =
              sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
          cellName.value = reports[i].name;

          final cellphone =
              sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
          cellphone.value = reports[i].phone;

          final cellphoneOptional =
              sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
          cellphoneOptional.value = reports[i].optionalPhone;

          final cellRegionName =
              sheetObject.cell(CellIndex.indexByString("D${i + 2}"));
          cellRegionName.value = reports[i].region!.name;

          final cellAddressDetails =
              sheetObject.cell(CellIndex.indexByString("E${i + 2}"));
          cellAddressDetails.value = reports[i].addressDetails;

          // final cellName =
          //     sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
          // cellName.value = reports[i].name;
          // final cellphone =
          //     sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
          // cellphone.value = reports[i].phone;
          // final cellAddressDetails =
          //     sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
          // cellAddressDetails.value = reports[i].addressDetails;
          // final cellCheckDate =
          //     sheetObject.cell(CellIndex.indexByString("D${i + 2}"));
          // cellCheckDate.value = reports[i].checkDate == null
          //     ? ''
          //     : DateFormat('yyyy-MM-dd').format(reports[i].checkDate!);
          // final cellUserIsReceived =
          //     sheetObject.cell(CellIndex.indexByString("E${i + 2}"));
          // cellUserIsReceived.value = reports[i].userIsReceived;
          // final cellPatientIsCame =
          //     sheetObject.cell(CellIndex.indexByString("F${i + 2}"));
          // cellPatientIsCame.value = reports[i].patientIsCame;
          // final cellEmployeeName =
          //     sheetObject.cell(CellIndex.indexByString("G${i + 2}"));
          // cellEmployeeName.value = reports[i].shortUser!.name;
          // final cellRegionName =
          //     sheetObject.cell(CellIndex.indexByString("H${i + 2}"));
          // cellRegionName.value = reports[i].region!.name;
          // final cellPriority =
          //     sheetObject.cell(CellIndex.indexByString("I${i + 2}"));
          // cellPriority.value = reports[i].priority!.color;

          // if (reports[i].reportlogs!.isNotEmpty) {
          //   final cellLastLogName =
          //       sheetObject.cell(CellIndex.indexByString("J${i + 2}"));
          //   cellLastLogName.value = reports[i]
          //       .reportlogs![reports[i].reportlogs!.length - 1]
          //       .result!
          //       .name;
          //   final cellLastLogType =
          //       sheetObject.cell(CellIndex.indexByString("K${i + 2}"));
          //   cellLastLogType.value = reports[i]
          //       .reportlogs![reports[i].reportlogs!.length - 1]
          //       .result!
          //       .type;
          //   final cellLastLogDetails =
          //       sheetObject.cell(CellIndex.indexByString("L${i + 2}"));
          //   cellLastLogDetails.value = reports[i]
          //       .reportlogs![reports[i].reportlogs!.length - 1]
          //       .details;
          //   final cellLastLogDate =
          //       sheetObject.cell(CellIndex.indexByString("M${i + 2}"));
          //   cellLastLogDate.value = DateFormat('yyyy-MM-dd').format(
          //       reports[i].reportlogs![reports[i].reportlogs!.length - 1].date);
          // }
        }

        //Save file
        saveExcelFile(sheetName, excel);
      } else {
        CustomToast.showDefault('لا يوجد تقارير لطباعتها');
      }
    } on CustomException catch (e) {
      CustomToast.closeLoading();
      CustomToast.showError(e.error);
    }
  }

  void saveExcelFile(String sheetName, Excel excel) async {
    try {
      final Directory dir = Directory('/storage/emulated/0/Bank AlDawa');
      if (!(await dir.exists())) {
        await dir.create(recursive: true);
      }

      File("${dir.path}/$sheetName.xlsx")
        ..createSync(recursive: false)
        ..writeAsBytesSync(excel.encode()!);

      CustomToast.showDefault('تم تصدير ملف الإكسل بنجاح');
    } catch (e) {
      developer.log('excel_error: $e');
    }
  }
}
