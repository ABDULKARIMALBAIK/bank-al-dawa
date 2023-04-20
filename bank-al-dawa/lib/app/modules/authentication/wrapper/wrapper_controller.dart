import 'package:bank_al_dawa/app/core/exceptions/exceptions.dart';
import 'package:bank_al_dawa/app/core/models/app_models/constant_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/report_model.dart';
import 'package:bank_al_dawa/app/core/models/user_models/user_model.dart';
import 'package:bank_al_dawa/app/core/services/request_manager.dart';
import 'package:bank_al_dawa/app/modules/authentication/shared/auth_repository.dart';
import 'package:bank_al_dawa/app/modules/authentication/shared/constant/auth_routes.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/constant/dashboard_routes.dart';
import 'package:get/get.dart';

import '../../../core/helper/data_helper.dart';
import '../../../core/services/getx_storage_controller.dart';

class WrapperController extends GetxStorageController {
  final AuthRepository authRepository;
  WrapperController({required this.authRepository});

  @override
  void onInit() {
    getStatus();
    super.onInit();
  }

  void getStatus() {
    requestMethod(
      ids: ["WrapperView"],
      requestType: RequestType.getData,
      function: () async {
        await Future.delayed(const Duration(seconds: 1));
        final User? user = storageService.userBox.getUser();
        if (user == null) {
          await Get.offAllNamed(AuthRoutes.loginRoute);
        } else {
          DataHelper.user = user;
          downloadReports();
          // if (storageService.reportBox.isEmptyReportBox) {
          //   await downloadReports();
          // }
          if (storageService.constantBox.getResults().isEmpty) {
            await getConstants(true);
          } else {
            getConstants();
          }
          await Get.offAllNamed(DashboardRoutes.homeRoute);
        }
        return null;
      },
    );
  }

  Future<CustomException?> getConstants([bool isNeeded = false]) async {
    try {
      final ConstantModel constant = await authRepository.getConstants();
      DataHelper.setConstants(constant);
      storageService.constantBox.setConstants(constant);
      return null;
    } on CustomException {
      //Offline Mode setup local variables by local storage
      final ConstantModel constantOffline = ConstantModel(
          priorities: storageService.constantBox.getPriorities(),
          regions: storageService.constantBox.getRegions(),
          results: storageService.constantBox.getResults(),
          types: storageService.constantBox.getTypes(),
          users: storageService.userBox.getAllUsers());
      DataHelper.setConstants(constantOffline);

      if (isNeeded) {
        rethrow;
      } else {
        return null;
      }
    }
  }

  Future<CustomException?> downloadReports() async {
    try {
      final List<Report> reports = await authRepository.getReports();
      storageService.reportBox.setReports(reports);
      return null;
    } on CustomException {
      rethrow;
    }
  }
}
