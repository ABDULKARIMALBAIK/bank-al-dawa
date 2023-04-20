// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

import '../../services/data_list.dart';

class NotificationModel extends PaginationId implements Equatable {
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.priority,
    required this.date,
    required this.isRead,
    required this.reportId,
  }) {
    lastId = int.parse(id);
  }

  final String id;
  final String title;
  final String body;
  final int priority;
  final DateTime date;
  final bool isRead;
  final int? reportId;
  static List<NotificationModel> notificationsFromJson(dynamic data) =>
      List<NotificationModel>.from((data as List)
          .map((notification) => NotificationModel.fromJson(notification)));

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"] ?? '0',
        title: json["title"] ?? 'notification title',
        body: json["body"] ?? 'notification body',
        priority: json["priority"] ?? 0,
        date: DateTime.parse(json["date"] ?? DateTime.now()),
        isRead: json["is_read"] ?? true,
        reportId:
            json["report_id"] == null ? null : int.parse(json["report_id"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "priority": priority,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "is_read": isRead,
      };

  @override
  List<Object?> get props => [id, title, body, priority, date, isRead];

  @override
  bool? get stringify => true;
}
