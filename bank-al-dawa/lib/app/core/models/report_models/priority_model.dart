import 'package:bank_al_dawa/app/core/models/report_models/report_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class PriorityModel {
  PriorityModel({
    required this.id,
    required this.color,
  });

  @Id(assignable: true)
  final int id;

  final String color;
  @Backlink('priorityModelRelation')
  final ToMany<Report> reports = ToMany<Report>();
  factory PriorityModel.fromMap(Map<String, dynamic> json) => PriorityModel(
        id: int.parse(json["id"]),
        color: json["color"],
      );
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "color": color,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
