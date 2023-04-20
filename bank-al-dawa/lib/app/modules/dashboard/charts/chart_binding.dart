import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:get/get.dart';

import 'chart_controller.dart';

class ChartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
        ChartController(dashboardRepository: Get.find<DashboardRepository>()));
  }
}
