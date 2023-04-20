import 'package:bank_al_dawa/app/core/models/report_models/report_model.dart';

class UpdateReport {
  UpdateReport({
    required this.deletedIds,
    required this.updatedRows,
    required this.newRows,
  });

  final List<int> deletedIds;
  final List<Report> updatedRows;
  final List<Report> newRows;

  factory UpdateReport.fromMap(Map<String, dynamic> json) => UpdateReport(
        deletedIds: List<int>.from(json["deletedIds"].map((x) => int.parse(x))),
        updatedRows: List<Report>.from(
            json["updatedRows"].map((x) => Report.fromMap(x))),
        newRows:
            List<Report>.from(json["newRows"].map((x) => Report.fromMap(x))),
      );
}
