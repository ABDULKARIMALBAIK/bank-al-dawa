import 'package:bank_al_dawa/app/core/services/storage/storage_service.dart';
import 'package:bank_al_dawa/app/modules/drawer/shared/drawer_repository.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'app/core/dio/factory.dart';
import 'app/modules/dashboard/shared/dashboard_repository.dart';

class AppInitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      StorageService.instance,
      permanent: true,
    );
    Get.put(
      DioFactory.dioSetUp(),
      permanent: true,
    );

    Get.put(DrawerRepository(dio: Get.find<Dio>()));
    Get.put(DashboardRepository(dio: Get.find<Dio>()));
  }
}
