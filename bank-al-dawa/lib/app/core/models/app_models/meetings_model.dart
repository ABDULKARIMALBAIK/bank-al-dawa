import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class MeetingModel extends Equatable {
  MeetingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  String id;
  String title;
  String description;
  DateTime date;
  static List<MeetingModel> meetingsFromJson(dynamic data) =>
      List<MeetingModel>.from(
          (data as List).map((meeting) => MeetingModel.fromJson(meeting)));
  factory MeetingModel.fromJson(Map<String, dynamic> json) => MeetingModel(
        id: json["id"] ?? '0',
        title: json["title"] ?? 'title',
        description: json["description"] ?? 'description',
        date: DateTime.parse(json["date"] ?? DateTime.now()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };

  @override
  List<Object?> get props => [id, title, description, date];
}
