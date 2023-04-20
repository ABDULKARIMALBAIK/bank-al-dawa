import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  HomeModel({
    this.earliestCheckDate,
    this.unfinishedReports = 0,
    // this.numberOfNewNotifications = 0,
    this.doneForThisWeek = 0,
  });

  DateTime? earliestCheckDate;
  int unfinishedReports;
  // int numberOfNewNotifications;
  int doneForThisWeek;

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        earliestCheckDate: DateTime.parse(json["earliestCheckDate"]),
        unfinishedReports: json["unfinishedReports"],
        // numberOfNewNotifications: json["numberOfNewNotifications"],
        doneForThisWeek: json["doneForThisWeek"],
      );

  Map<String, dynamic> toJson() => {
        "earliestCheckDate":
            "${earliestCheckDate!.year.toString().padLeft(4, '0')}-${earliestCheckDate!.month.toString().padLeft(2, '0')}-${earliestCheckDate!.day.toString().padLeft(2, '0')}",
        "unfinishedReports": unfinishedReports,
        // "numberOfNewNotifications": numberOfNewNotifications,
        "doneForThisWeek": doneForThisWeek,
      };
}
