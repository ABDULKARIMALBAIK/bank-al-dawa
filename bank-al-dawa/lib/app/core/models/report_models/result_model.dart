import 'package:bank_al_dawa/app/core/models/report_models/report_log_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ResultModel {
  ResultModel({
    required this.id,
    required this.name,
    required this.type,
  });
  @Id(assignable: true)
  final int id;

  final String name;
  final String type;
  @Backlink('resultModelRelation')
  final ToMany<ReportLog> reportModels = ToMany<ReportLog>();
  factory ResultModel.fromMap(Map<String, dynamic> json) => ResultModel(
        id: int.parse(json["id"]),
        name: json["name"],
        type: json["type"],
      );
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "type": type,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
