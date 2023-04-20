import 'package:bank_al_dawa/app/modules/authentication/shared/auth_repository.dart';
import 'package:bank_al_dawa/app/modules/authentication/wrapper/wrapper_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class WrapperBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository(dio: Get.find<Dio>()), permanent: true);
    Get.put(WrapperController(authRepository: Get.find<AuthRepository>()));
  }
}
