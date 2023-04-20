import 'package:bank_al_dawa/app/core/services/state_provider.dart';
import 'package:get/get.dart';

import '../exceptions/exceptions.dart';
import '../widgets/toast.dart';
import '../widgets/widget_state.dart';

mixin RequestManager on StateProvider {
  Future<void> requestMethod<R>({
    required List<String> ids,
    required RequestType requestType,
    required Future<List<R>?> Function() function,
    List<String>? stateLessIds,
    bool showToastLoading = false,
    String? errorMessage,
    String? loadedMessage,
  }) async {
    try {
      if (showToastLoading) {
        CustomToast.showLoading();
      }
      _loadingHandler(ids: ids, requestType: requestType);
      final List<R>? list = await function();
      _loadedHandler<R>(
        ids: ids,
        requestType: requestType,
        list: list,
        stateLessIds: stateLessIds,
      );
      if (loadedMessage != null) {
        CustomToast.showDefault(loadedMessage.tr);
      }
      CustomToast.closeLoading();
    } on CustomException catch (e) {
      CustomToast.closeLoading();
      _errorHandler(ids: ids, requestType: requestType);
      if (errorMessage != null) {
        CustomToast.showDefault(errorMessage.tr);
      } else {
        CustomToast.showError(e.error);
      }
    }
  }

  void _loadedHandler<R>({
    required List<String> ids,
    required RequestType requestType,
    required List<R>? list,
    List<String>? stateLessIds,
  }) {
    if (stateLessIds != null) {
      updateState(stateLessIds, WidgetState.loaded);
    }
    switch (requestType) {
      case RequestType.getData:
        if (list != null) {
          if (list.isEmpty) {
            updateState(ids, WidgetState.noResults);
            CustomToast.showDefault("لا يوجد نتائج"); //No results found
          } else {
            updateState(ids, WidgetState.loaded);
          }
        } else {
          updateState(ids, WidgetState.error);
        }
        break;
      case RequestType.postData:
        updateState(ids, WidgetState.loaded);
        break;
      case RequestType.loadingMore:
        if (list != null) {
          if (list.isEmpty) {
            updateState(ids, WidgetState.noMoreData);
            CustomToast.showDefault(
                "لا يوجد المزيد من البيانات"); //No more data
          } else {
            updateState(ids, WidgetState.loaded);
          }
        }
        break;
      case RequestType.refresh:
        updateState(ids, WidgetState.loaded);
        break;
    }
  }

  void _loadingHandler({
    required List<String> ids,
    required RequestType requestType,
  }) {
    switch (requestType) {
      case RequestType.getData:
        updateState(ids, WidgetState.loading);
        break;
      case RequestType.postData:
        updateState(ids, WidgetState.loading);
        break;
      case RequestType.loadingMore:
        updateState(ids, WidgetState.loadingMore);
        break;
      case RequestType.refresh:
        break;
    }
  }

  void _errorHandler({
    required List<String> ids,
    required RequestType requestType,
  }) {
    switch (requestType) {
      case RequestType.getData:
        updateState(ids, WidgetState.error);
        break;
      case RequestType.postData:
        updateState(ids, WidgetState.loaded);
        break;
      case RequestType.loadingMore:
        updateState(ids, WidgetState.loaded);
        break;
      case RequestType.refresh:
        updateState(ids, WidgetState.loaded);
        break;
    }
  }
}

enum RequestType {
  getData,
  postData,
  loadingMore,
  refresh,
}
