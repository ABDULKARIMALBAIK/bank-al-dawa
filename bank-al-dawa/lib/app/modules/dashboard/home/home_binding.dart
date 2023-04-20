import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
        HomeController(dashboardRepository: Get.find<DashboardRepository>()));
  }
}
