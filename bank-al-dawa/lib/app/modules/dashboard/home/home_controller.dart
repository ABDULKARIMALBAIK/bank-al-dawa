import 'dart:async';

import 'package:bank_al_dawa/app/core/helper/data_helper.dart';
import 'package:bank_al_dawa/app/core/models/app_models/home_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/update_report_model.dart';
import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/core/widgets/toast.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:bank_al_dawa/app/modules/drawer/shared/constant/drawer_routes.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/models/app_models/region_model.dart';
import '../../../core/models/report_models/report_model.dart';
import '../../../core/models/user_models/user_model.dart';
import '../../../core/services/data_list.dart';
import '../../../core/widgets/widget_state.dart';
import '../../authentication/shared/constant/auth_routes.dart';
import '../shared/constant/dashboard_routes.dart';

class HomeController extends GetxStorageController
    with DataList<Report>, GetSingleTickerProviderStateMixin {
  DashboardRepository dashboardRepository;

  late AnimationController bottomSheetAnimationController;

  ScrollController scrollController = ScrollController();
  SwiperPagination swiperPagination = const SwiperPagination();
  SwiperControl swiperControl = const SwiperControl();
  late Stream<ConnectivityResult> connectivityController;

  SwiperController swiperController = SwiperController();
  int chartPieIndexTouched = -1;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String buildHomeScreen = 'buildHomeScreen';
  String buildWifi = 'buildWifi';
  String buildReports = 'buildReports';
  String employeeOldId = 'employeeOldId';
  String employeeNewId = 'employeeNewId';

  final List<Report> localReports = [];
  HomeModel? homeModel;

  bool isDark = false;
  String isArabic = 'arabic';

  String selectedOldEmployee = '';
  String selectedNewEmployee = '';
  String changeRegionId = '';
  String regionId = '';

  String changeRegionBottomSheetId = 'changeRegionBottomSheetId';
  String regionBottomSheetId = 'regionBottomSheetId';

  @override
  void onInit() async {
    bottomSheetAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    connectivityController = Connectivity().onConnectivityChanged;
    await loadHomeData();
    updateState([buildWifi], WidgetState.loaded);

    Future.delayed(const Duration(milliseconds: 2000))
        .then((value) => update([buildReports]));
    super.onInit();
  }

  @override
  void dispose() async {
    // connectivityController.drain();
    scrollController.dispose();

    super.dispose();
  }

  HomeController({required this.dashboardRepository});

  void logoutAccount() {
    CustomToast.showLoading();

    //Clear Database
    storageService.clearDB();

    //Delete account from DataHelper
    DataHelper.user = null;

    CustomToast.closeLoading();

    //Go To Wrapper Screen
    Get.offAllNamed(AuthRoutes.loginRoute);
  }

  Future<void> loadHomeData({bool showLoadingDialog = false}) async {
    try {
      if (showLoadingDialog) {
        CustomToast.showLoading();
      } else {
        updateState([buildHomeScreen], WidgetState.loading);
      }

      await updateReports(showLoadingDialog: showLoadingDialog);

      homeModel = await dashboardRepository.loadHomeData();
      updateState([buildHomeScreen], WidgetState.loaded);
      // update([buildReports]);
    } on CustomException {
      if (showLoadingDialog) {
        CustomToast.closeLoading();
      } else {
        updateState([buildHomeScreen], WidgetState.loaded);
        update([buildReports]);
      }

      CustomToast.showDefault('انت غير متصل بالشبكة');
      // CustomToast.showError(e.error);
    }
  }

  Future<void> updateReports({bool showLoadingDialog = false}) async {
    try {
      if (showLoadingDialog) {
        CustomToast.showLoading();
      }

      final UpdateReport updateReport =
          await dashboardRepository.getUpdateReports();
      storageService.reportBox.updateReports(updateReport);

      updateLocalReports();
      // update([buildReports]);

      // await dashboardRepository.getReports();

      if (showLoadingDialog) {
        CustomToast.closeLoading();
      }

      CustomToast.showDefault('تم تحديث البيانات بنجاح');
    } on CustomException {
      if (showLoadingDialog) {
        CustomToast.closeLoading();
      } else {
        updateState([buildHomeScreen], WidgetState.loaded);
        update([buildReports]);
      }
      CustomToast.showDefault('انت غير متصل بالشبكة');
      // rethrow;
    }
  }

  void updateLocalReports() {
    localReports.clear();

    List<Report> tempReports = [];
    // final List<Report> finalListReports = [];

    tempReports = storageService.reportBox.getAllReports(page: 0, limit: 10);

    // for (int i = 0; i < tempReports.length; i++) {
    //   if (tempReports[i].reportlogs != null) {
    //     if (tempReports[i].reportlogs!.isEmpty) {
    //       finalListReports.add(tempReports[i]);
    //     }
    //   } else {
    //     finalListReports.add(tempReports[i]);
    //   }
    // }

    localReports.addAll(tempReports);
    update([buildReports]);
  }

  Future<void> transferReports(BuildContext context) async {
    if (selectedOldEmployee.isEmpty) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) =>
          CustomToast.showDefault(
              'رجاء اختر الموظف المناسب لنقل الكشوفات منه'));
    } else if (selectedNewEmployee.isEmpty) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) =>
          CustomToast.showDefault(
              'رجاء اختر الموظف المناسب لنقل الكشوفات إليه'));
    } else if (checkSameUser()) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) =>
          CustomToast.showDefault('لا تختر نفس الموظف ، حاول مرة اخرى'));
    } else {
      try {
        CustomToast.showLoading();
        await Future.delayed(const Duration(milliseconds: 100));

        //Get old User Id
        int userOldId = 1;
        for (User user in DataHelper.employees) {
          if (user.name == selectedOldEmployee) {
            userOldId = user.id;
          }
        }

        //Get new User Id
        int userNewId = 1;
        for (User user in DataHelper.employees) {
          if (user.name == selectedNewEmployee) {
            userNewId = user.id;
          }
        }

        //Get Region Id   (regionId)
        String selectedRegion = '';
        if (regionId.isNotEmpty) {
          for (RegionModel region in DataHelper.regions) {
            if (region.name == regionId) {
              selectedRegion = region.id.toString();
            }
          }
        }

        final bool result = await dashboardRepository.transferReports(
            oldUser: userOldId, newUser: userNewId, regionId: selectedRegion);

        if (result) {
          CustomToast.closeLoading();

          // ignore: use_build_context_synchronously
          Navigator.pop(context);

          Future.delayed(const Duration(milliseconds: 200)).then((value) =>
              CustomToast.showDefault(
                  'تم نقل الكشوفات من $selectedOldEmployee الى $selectedNewEmployee بنجاح'));
        } else {
          CustomToast.closeLoading();
          CustomToast.showDefault('مشكلة ما حدثت');
        }
      } on CustomException catch (e) {
        CustomToast.closeLoading();
        CustomToast.showError(e.error);
      }
    }
  }

  bool checkSameUser() {
    if (selectedOldEmployee == selectedNewEmployee) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> changeRegion(BuildContext context) async {
    if (changeRegionId.isEmpty) {
      CustomToast.showDefault('اختر المنطقة أولاً');
    } else {
      try {
        CustomToast.showLoading();
        await Future.delayed(const Duration(milliseconds: 100));

        //Get Region Id
        RegionModel? selectedRegion;
        for (RegionModel region in DataHelper.regions) {
          if (region.name == changeRegionId) {
            selectedRegion = region;
          }
        }

        if (selectedRegion == null) {
          return;
        }

        final bool result = await dashboardRepository.changeRegion(
          regionId: selectedRegion.id.toString(),
          regionName: selectedRegion.name,
          userId: DataHelper.accountUser!.id.toString(),
        );

        if (result) {
          //Update local data
          if (DataHelper.user!.regions == null) {
            DataHelper.user!.regions = <RegionModel>[];
            DataHelper.user!.regions!.add(selectedRegion);
          } else {
            if (DataHelper.user!.regions!.isEmpty) {
              DataHelper.user!.regions!.add(selectedRegion);
            } else {
              DataHelper.user!.regions![0] = selectedRegion;
            }
          }
          storageService.userBox.setUser(DataHelper.user!);

          //Complete the process
          CustomToast.closeLoading();

          // ignore: use_build_context_synchronously
          Navigator.pop(context);

          Future.delayed(const Duration(milliseconds: 200)).then(
              (value) => CustomToast.showDefault('تم تغيير منطقة العمل بنجاح'));
        } else {
          CustomToast.closeLoading();
          CustomToast.showDefault('مشكلة ما حدثت');
        }
      } on CustomException catch (e) {
        CustomToast.closeLoading();
        CustomToast.showError(e.error);
      }
    }
  }

  void goToManageAccounts() => Get.toNamed(DrawerRoutes.manageAccountsRoute);
  void goToCharts() => Get.toNamed(DashboardRoutes.chartRoute);
  void goToNonDeliveredReports() =>
      Get.toNamed(DashboardRoutes.nonDeliveredReportsRoute);
  void goToNotifications() => Get.toNamed(DashboardRoutes.notificationRoute);
  void goToFeaturedReports() =>
      Get.toNamed(DrawerRoutes.featuredStatementsRoute);
  void goToAllReports() => Get.toNamed(DashboardRoutes.allReportsRoute);
  void goToCalendar() => Get.toNamed(DashboardRoutes.calendarRoute);
  void goToMeetings() => Get.toNamed(DrawerRoutes.meetingsRoute);
  void goToRegisterReport() =>
      Get.toNamed(DashboardRoutes.registerReportRoute, arguments: [
        {"from_non_home": false}
      ]);
  void goToRegisterAccount() =>
      Get.toNamed(AuthRoutes.registerRoute, arguments: [
        {"from_manage_accounts": false},
      ]);

  void goToManageRegions() => Get.toNamed(DrawerRoutes.manageRegionsRoute);
}
