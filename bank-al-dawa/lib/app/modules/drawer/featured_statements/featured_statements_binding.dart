import 'package:bank_al_dawa/app/modules/drawer/shared/drawer_repository.dart';
import 'package:get/get.dart';

import 'featured_statements_controller.dart';

class FeatureStatementsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FeaturedStatementsController(
        drawerRepository: Get.find<DrawerRepository>()));
  }
}
