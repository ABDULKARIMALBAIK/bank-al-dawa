import 'dart:developer';

import 'package:bank_al_dawa/app/core/services/request_manager.dart';
import 'package:bank_al_dawa/app/core/widgets/toast.dart';

abstract class PaginationId {
  int lastId = 0;
}

mixin DataList<T extends PaginationId> on RequestManager {
  int _page = 0;
  int _lastId = 0;
  final List<T> _dataList = [];
  Future<void> handelDataList({
    required List<String> ids,
    required RequestType requestType,
    required Future<List<T>> Function() function,
    String? errorMessage,
    String? loadedMessage,
  }) async {
    switch (requestType) {
      case RequestType.getData:
        requestMethod(
            ids: ids,
            requestType: RequestType.getData,
            function: () async {
              _lastId = 0;
              _page = 0;
              final List<T> tempDataList = await function();
              _dataList.clear();
              _dataList.addAll(tempDataList);
              if (_dataList.isNotEmpty) {
                _lastId = _dataList.last.lastId;
              }
              _page = 1;
              log(tempDataList.toString());
              return tempDataList;
            });
        break;
      case RequestType.postData:
        break;
      case RequestType.loadingMore:
        requestMethod(
            ids: ids,
            requestType: RequestType.loadingMore,
            function: () async {
              final List<T> tempDataList = await function();
              _dataList.addAll(tempDataList);
              if (_dataList.isNotEmpty) {
                _lastId = _dataList.last.lastId;
              }
              if (tempDataList.isEmpty) {
                CustomToast.showDefault("لا يوجد بيانات إضافية");
              }
              _page++;
              return tempDataList;
            });
        break;
      case RequestType.refresh:
        requestMethod(
            ids: ids,
            requestType: RequestType.refresh,
            function: () async {
              _lastId = 0;
              _page = 0;
              final List<T> tempDataList = await function();
              _dataList.clear();
              _dataList.addAll(tempDataList);
              if (_dataList.isNotEmpty) {
                _lastId = _dataList.last.lastId;
              }
              _page = 1;
              return tempDataList;
            });
        break;
    }
  }

  List<T> get dataList => _dataList;
  int get lastId => _lastId;
  void setLastId(int lastId) => _lastId = lastId;
  int get page => _page;
}
