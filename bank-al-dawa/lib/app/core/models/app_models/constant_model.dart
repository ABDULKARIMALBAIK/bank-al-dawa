import 'package:bank_al_dawa/app/core/models/app_models/region_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/priority_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/result_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/type_model.dart';
import 'package:bank_al_dawa/app/core/models/user_models/user_model.dart';

class ConstantModel {
  ConstantModel({
    required this.regions,
    required this.priorities,
    required this.types,
    required this.users,
    required this.results,
  });

  final List<RegionModel> regions;
  final List<PriorityModel> priorities;
  final List<TypeModel> types;
  final List<User> users;
  final List<ResultModel> results;

  factory ConstantModel.fromMap(Map<String, dynamic> json) => ConstantModel(
        regions: json["regions"] == null
            ? []
            : List<RegionModel>.from(
                json["regions"].map((x) => RegionModel.fromMap(x))),
        priorities: json["priorities"] == null
            ? []
            : List<PriorityModel>.from(
                json["priorities"].map((x) => PriorityModel.fromMap(x))),
        types: json["types"] == null
            ? []
            : List<TypeModel>.from(
                json["types"].map((x) => TypeModel.fromMap(x))),
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"].map((x) => User.fromJson(x))),
        results: json["results"] == null
            ? []
            : List<ResultModel>.from(
                json["results"].map((x) => ResultModel.fromMap(x))),
      );
}
