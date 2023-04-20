import 'package:bank_al_dawa/app/core/models/report_models/report_log_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/report_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ShortUser {
  ShortUser({
    required this.id,
    required this.name,
  });

  factory ShortUser.fromMap(Map<String, dynamic> json) => ShortUser(
        id: int.parse(json["id"]),
        name: json["name"],
      );

  final String name;

  @Id(assignable: true)
  final int id;

  @Backlink('shortUserRelationReportLog')
  final ToMany<ReportLog> reportLogs = ToMany<ReportLog>();
  @Backlink('shortUserRelationReport')
  final ToMany<Report> reports = ToMany<Report>();
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
