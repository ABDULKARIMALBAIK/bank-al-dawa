import 'package:bank_al_dawa/app/core/services/request_manager.dart';
import 'package:bank_al_dawa/app/core/services/state_provider.dart';
import 'package:bank_al_dawa/app/core/services/storage/storage_service.dart';
import 'package:get/get.dart';

abstract class GetxStorageController<T> extends GetxController
    with StateMixin<T>, StateProvider, RequestManager {
  StorageService get storageService => Get.find<StorageService>();
}
