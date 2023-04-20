import 'dart:convert';

SecondPieChartModel secondPieChartModelFromJson(String str) =>
    SecondPieChartModel.fromJson(json.decode(str));

String secondPieChartModelToJson(SecondPieChartModel data) =>
    json.encode(data.toJson());

class SecondPieChartModel {
  SecondPieChartModel({
    this.aCount = 0,
    this.bCount = 0,
    this.cCount = 0,
    this.dCount = 0,
    this.xCount = 0,
  });

  int aCount;
  int bCount;
  int cCount;
  int dCount;
  int xCount;

  factory SecondPieChartModel.fromJson(Map<String, dynamic> json) =>
      SecondPieChartModel(
        aCount: json["ACount"],
        bCount: json["BCount"],
        cCount: json["CCount"],
        dCount: json["DCount"],
        xCount: json["XCount"],
      );

  Map<String, dynamic> toJson() => {
        "ACount": aCount,
        "BCount": bCount,
        "CCount": cCount,
        "DCount": dCount,
        "XCount": xCount,
      };
}
