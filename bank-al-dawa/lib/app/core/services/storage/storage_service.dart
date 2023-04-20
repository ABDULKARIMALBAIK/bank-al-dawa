import 'dart:core';
import 'dart:developer';

import 'package:bank_al_dawa/app/core/helper/data_helper.dart';
import 'package:bank_al_dawa/app/core/models/app_models/constant_model.dart';
import 'package:bank_al_dawa/app/core/models/app_models/permission_model.dart';
import 'package:bank_al_dawa/app/core/models/app_models/region_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/priority_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/report_log_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/report_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/result_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/short_user_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/type_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/update_report_model.dart';
import 'package:bank_al_dawa/objectbox.g.dart';
import 'package:flutter/services.dart';

import '../../models/user_models/user_model.dart';

part 'boxes/constant_box.dart';
part 'boxes/report_box.dart';
part 'boxes/user_box.dart';

class StorageService {
  StorageService._internal();
  late Store store;

  Future<void> openDatabaseStore({Store? storeIsolate}) async {
    try {
      if (storeIsolate != null) {
        store = storeIsolate;
      } else {
        store = await openStore();
        log("Database Store opened successfully");
        // clearDB();
      }
    } catch (e) {
      log("ObjectBoxException from openDatabaseStore: $e");
    }
  }

  ByteData get getStoreReference => instance.store.reference;

  void clearDB() {
    userBox.clearUserBox();
    constantBox.clearConstantBox();
    reportBox.clearReportBox();
  }

  UserBox get userBox => UserBox._internal();
  ReportBox get reportBox => ReportBox._internal();
  ConstantBox get constantBox => ConstantBox._internal();

  static final StorageService instance = StorageService._internal();
}
