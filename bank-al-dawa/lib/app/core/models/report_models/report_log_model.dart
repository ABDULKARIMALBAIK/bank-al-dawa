import 'package:bank_al_dawa/app/core/models/report_models/report_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/result_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/short_user_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ReportLog {
  ReportLog({
    required this.id,
    required this.date,
    required this.details,
    required this.note,
    this.shortUser,
    this.result,
    Report? report,
  }) {
    if (report != null) {
      this.report.target = report;
    }
  }

  factory ReportLog.fromMap(Map<String, dynamic> json, {Report? report}) {
    final ReportLog reportModel = ReportLog(
      id: int.parse(json["id"]),
      date: DateTime.parse(json["date"]),
      details: json["details"] ?? '',
      note: json["note"] ?? '',
      report: report,
    );
    if (json["user"] != null) {
      reportModel.shortUser = ShortUser.fromMap(json["user"]);
    }
    reportModel.result = ResultModel.fromMap(json["result"]);

    return reportModel;
  }

  final ToOne<ResultModel> resultModelRelation = ToOne<ResultModel>();
  final ToOne<ShortUser> shortUserRelationReportLog = ToOne<ShortUser>();
  final ToOne<Report> report = ToOne<Report>();
  @Property(type: PropertyType.date)
  final DateTime date;

  String details;
  @Id(assignable: true)
  final int id;

  bool isSelected = false;

  String note;

  @Transient()
  ResultModel? result;

  @Transient()
  ShortUser? shortUser;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "note": note,
      "details": details,
      "result": result?.toMap(),
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  static List<ReportLog> reportLogList(List data, {Report? report}) => data
      .map((reportMap) => ReportLog.fromMap(reportMap, report: report))
      .toList();

  set setShortUser(ShortUser shortUser) => this.shortUser = shortUser;
}
