import 'package:bank_al_dawa/app/modules/authentication/shared/auth_repository.dart';
import 'package:get/get.dart';

import 'register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterController(authRepository: Get.find<AuthRepository>()));
  }
}
