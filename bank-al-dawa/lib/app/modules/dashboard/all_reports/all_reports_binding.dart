import 'package:bank_al_dawa/app/modules/dashboard/all_reports/all_reports_controller.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:get/get.dart';

class AllReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AllReportsController(
        dashboardRepository: Get.find<DashboardRepository>()));
  }
}
