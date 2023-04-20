import 'package:bank_al_dawa/app/modules/authentication/login/login_controller.dart';
import 'package:bank_al_dawa/app/modules/authentication/shared/auth_repository.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController(authRepository: Get.find<AuthRepository>()));
  }
}
