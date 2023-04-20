import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:get/get.dart';

import 'calendar_controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CalendarController(
        dashboardRepository: Get.find<DashboardRepository>()));
  }
}
