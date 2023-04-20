import 'dart:convert';

FirstPieChartModel firstPieChartModelFromJson(String str) =>
    FirstPieChartModel.fromJson(json.decode(str));

String firstPieChartModelToJson(FirstPieChartModel data) =>
    json.encode(data.toJson());

class FirstPieChartModel {
  FirstPieChartModel({
    this.doneCount = 0,
    this.alibiCount = 0,
    this.alibiPlusCount = 0,
    this.unfinishedReports = 0,
  });

  int doneCount;
  int alibiCount;
  int alibiPlusCount;
  int unfinishedReports;

  factory FirstPieChartModel.fromJson(Map<String, dynamic> json) =>
      FirstPieChartModel(
        doneCount: json["doneCount"],
        alibiCount: json["alibiCount"],
        alibiPlusCount: json["alibiPlusCount"],
        unfinishedReports: json["unfinishedReports"],
      );

  Map<String, dynamic> toJson() => {
        "doneCount": doneCount,
        "alibiCount": alibiCount,
        "alibiPlusCount": alibiPlusCount,
        "unfinishedReports": unfinishedReports,
      };
}
