import 'package:bank_al_dawa/app/modules/drawer/meetings/meetings_controller.dart';
import 'package:bank_al_dawa/app/modules/drawer/shared/drawer_repository.dart';
import 'package:get/get.dart';

class MeetingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MeetingsController(drawerRepository: Get.find<DrawerRepository>()));
  }
}
