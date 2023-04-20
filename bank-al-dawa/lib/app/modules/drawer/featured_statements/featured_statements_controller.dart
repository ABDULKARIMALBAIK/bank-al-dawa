import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/modules/drawer/shared/drawer_repository.dart';
import 'package:flutter/cupertino.dart';

class FeaturedStatementsController extends GetxStorageController {
  DrawerRepository drawerRepository;

  ScrollController scrollController = ScrollController();
  bool isDark = false;

  @override
  void onInit() async {
    // isDark = await storageService.themeStorage.darkMode();
    super.onInit();
  }

  FeaturedStatementsController({required this.drawerRepository});

  // Future<void> login() async {
  //   try {} on CustomException catch (e) {
  //     CustomToast.showError(e.error);
  //   }
  // }
}
