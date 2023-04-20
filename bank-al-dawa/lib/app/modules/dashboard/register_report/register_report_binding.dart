import 'package:bank_al_dawa/app/modules/dashboard/register_report/register_report_controller.dart';
import 'package:bank_al_dawa/app/modules/dashboard/shared/dashboard_repository.dart';
import 'package:get/get.dart';

class RegisterReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterReportController(
        dashboardRepository: Get.find<DashboardRepository>()));
  }
}
