import 'package:bank_al_dawa/app/modules/drawer/shared/drawer_repository.dart';
import 'package:get/get.dart';

import 'manage_regions_controller.dart';

class ManageRegionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ManageRegionsController(
        drawerRepository: Get.find<DrawerRepository>()));
  }
}
