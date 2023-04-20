import 'package:bank_al_dawa/app/modules/dashboard/non_delivered_reports/non_delivered_reports_controller.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:get/get.dart';

class NonDeliveredReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NonDeliveredReportsController(
        dashboardRepository: Get.find<DashboardRepository>()));
  }
}
