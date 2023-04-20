import 'package:bank_al_dawa/app/modules/drawer/manage_accounts/manage_accounts_controller.dart';
import 'package:bank_al_dawa/app/modules/drawer/shared/drawer_repository.dart';
import 'package:get/get.dart';

class ManageAccountsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ManageAccountsController(
        drawerRepository: Get.find<DrawerRepository>()));
  }
}
