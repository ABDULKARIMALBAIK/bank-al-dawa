import 'package:bank_al_dawa/app/core/models/report_models/report_model.dart';
import 'package:bank_al_dawa/app/core/models/user_models/user_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class RegionModel {
  RegionModel({
    required this.id,
    required this.name,
  });
  @Id(assignable: true)
  final int id;
  final String name;
  @Backlink('regionModelRelation')
  final ToMany<Report> reports = ToMany<Report>();
  final ToMany<User> users = ToMany<User>();
  factory RegionModel.fromMap(Map<String, dynamic> json) => RegionModel(
        id: int.parse(json["id"]),
        name: json["name"],
      );
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
