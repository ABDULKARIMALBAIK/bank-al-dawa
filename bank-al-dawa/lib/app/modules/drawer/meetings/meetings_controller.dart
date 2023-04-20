import 'package:bank_al_dawa/app/core/models/app_models/meetings_model.dart';
import 'package:bank_al_dawa/app/core/services/getx_storage_controller.dart';
import 'package:bank_al_dawa/app/core/services/request_manager.dart';
import 'package:bank_al_dawa/app/core/widgets/widget_state.dart';
import 'package:bank_al_dawa/app/modules/drawer/shared/drawer_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/widgets/toast.dart';

class MeetingsController extends GetxStorageController {
  final DrawerRepository drawerRepository;
  final ScrollController scrollController = ScrollController();
  final String idState = 'meetingView';
  List<MeetingModel> meetings = [];

  MeetingsController({required this.drawerRepository});

  @override
  void onInit() {
    super.onInit();
    getMeetings();
  }

  Future<void> getMeetings() async {
    try {
      updateState([idState], WidgetState.loading);
      meetings = await drawerRepository.getMeetings();

      await requestMethod(
          ids: [idState],
          requestType: RequestType.getData,
          function: () async {
            return Future.value(meetings);
          });
      updateState([idState], WidgetState.loaded);
    } on CustomException catch (e) {
      updateState([idState], WidgetState.error);
      CustomToast.showError(e.error);
    }
  }
}
