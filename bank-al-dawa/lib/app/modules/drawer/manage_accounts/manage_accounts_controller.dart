import 'package:bank_al_dawa/app/core/models/user_models/user_model.dart';
import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/modules/authentication/shared/constant/auth_routes.dart';
import 'package:bank_al_dawa/app/modules/drawer/shared/drawer_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/services/data_list.dart';
import '../../../core/services/request_manager.dart';
import '../../../core/widgets/toast.dart';
import '../../../core/widgets/widget_state.dart';

class ManageAccountsController extends GetxStorageController
    with DataList<User> {
  ManageAccountsController({required this.drawerRepository});
  final DrawerRepository drawerRepository;
  final ScrollController scrollController = ScrollController();
  final String stateId = 'stateId';
  final String statePaginationId = 'statePaginationId';

  @override
  void onInit() async {
    getAccounts();
    super.onInit();
  }

  Future<void> getAccounts(
      {RequestType requestType = RequestType.getData}) async {
    try {
      if (requestType == RequestType.refresh) {
        updateState([stateId], WidgetState.loading);
      }

      if (requestType == RequestType.getData) {
        updateState([stateId], WidgetState.loading);
      }
      final List<User> users = await drawerRepository
          .getAccounts(requestType == RequestType.refresh ? 0 : lastId);

      await handelDataList(
          ids: [statePaginationId, stateId],
          requestType: requestType,
          function: () => Future.value(users));

      updateState([stateId], WidgetState.loaded);
    } on CustomException catch (e) {
      updateState([stateId], WidgetState.error);
      CustomToast.showError(e.error);
    }
  }

  Future<void> deleteAccount(User account) async {
    try {
      CustomToast.showLoading();
      await drawerRepository.deleteAccount(account.id.toString());
      dataList.remove(account);
    } on CustomException catch (e) {
      CustomToast.showError(e.error);
    }
    CustomToast.closeLoading();
    update([stateId]);
  }

  void goToRegisterAccount() {
    Get.toNamed(AuthRoutes.registerRoute, arguments: [
      {"from_manage_accounts": true},
    ])?.then((result) {
      if (result != null) {
        if (result[0]['isUpdated'] == true) {
          dataList[dataList.indexWhere(
                  (account) => account.id == DataHelper.accountUser!.id)] =
              DataHelper.accountUser!;
          update([stateId]);

          //getAccounts(requestType: RequestType.refresh)
        }
      }
    });
  }
}
