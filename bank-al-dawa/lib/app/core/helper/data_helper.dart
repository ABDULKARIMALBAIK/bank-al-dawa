import 'package:bank_al_dawa/app/core/models/app_models/constant_model.dart';
import 'package:bank_al_dawa/app/core/models/app_models/region_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/priority_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/result_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/type_model.dart';
import 'package:bank_al_dawa/app/core/models/user_models/user_model.dart';

import '../models/report_models/report_model.dart';

class DataHelper {
  static late List<User> employees;
  static late List<PriorityModel> priorities;
  static late List<RegionModel> regions;
  static Report? reportModel;
  static Report? ratingReportModel;
  static late List<ResultModel> results;
  static late List<TypeModel> types;
  static User? user;
  static User? accountUser;

  static void setConstants(ConstantModel constant) {
    employees = constant.users;
    regions = constant.regions;
    results = constant.results;
    types = constant.types;
    priorities = constant.priorities;
  }
}
