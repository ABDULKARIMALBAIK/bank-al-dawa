import 'package:bank_al_dawa/app/core/models/app_models/region_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/priority_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/report_log_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/short_user_model.dart';
import 'package:bank_al_dawa/app/core/models/report_models/type_model.dart';
import 'package:objectbox/objectbox.dart';

import '../../services/data_list.dart';

@Entity()
class Report extends PaginationId {
  Report({
    required this.id,
    required this.name,
    required this.phone,
    required this.checkDate,
    required this.visitDate,
    required this.userIsReceived,
    required this.patientIsCame,
    required this.createdAt,
    required this.updatedAt,
    required this.optionalPhone,
    required this.details,
    this.addressDetails,
    this.type,
    this.region,
    this.shortUser,
    this.priority,
    this.reportlogs,
  }) {
    lastId = id;
  }

  factory Report.fromMap(Map<String, dynamic> json) {
    final Report report = Report(
      id: int.parse(json["id"]),
      name: json["name"],
      phone: json["phone"],
      optionalPhone: json["optionalPhone"] ?? '',
      details: json["details"] ?? '',
      userIsReceived: json["userIsReceived"] ?? false,
      patientIsCame: json["patientIsCame"] ?? false,
      addressDetails: json["address_details"],
      checkDate: json["check_date"] == null
          ? null
          : DateTime.parse(json["check_date"]),
      visitDate: json["visit_date"] == null
          ? null
          : DateTime.parse(json["visit_date"]),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
    );
    report.type = TypeModel.fromMap(json["type"]);
    if (json["region"] != null) {
      report.region = RegionModel.fromMap(json["region"]);
    }
    if (json["logs"] != null) {
      report.reportlogs = ReportLog.reportLogList(json["logs"], report: report);
    }
    if (json["user"] != null) {
      report.shortUser = ShortUser.fromMap(json["user"]);
    }
    report.priority = PriorityModel.fromMap(json["priority"]);
    return report;
  }

  bool patientIsCame;
  final ToOne<PriorityModel> priorityModelRelation = ToOne<PriorityModel>();
  final ToOne<RegionModel> regionModelRelation = ToOne<RegionModel>();
  final ToOne<TypeModel> typeModelRelation = ToOne<TypeModel>();
  final ToOne<ShortUser> shortUserRelationReport = ToOne<ShortUser>();
  bool userIsReceived;

  @Property(type: PropertyType.date)
  DateTime? checkDate;

  @Property(type: PropertyType.date)
  final DateTime createdAt;

  @Id(assignable: true)
  final int id;

  String name;
  String phone;
  String optionalPhone;
  String details;
  bool isSelected = false;
  @Transient()
  PriorityModel? priority;

  @Transient()
  RegionModel? region;

  @Transient()
  List<ReportLog>? reportlogs;

  @Transient()
  TypeModel? type;

  @Property(type: PropertyType.date)
  final DateTime? updatedAt;

  @Property(type: PropertyType.date)
  final DateTime? visitDate;
  @Transient()
  ShortUser? shortUser;
  String? addressDetails;
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "OptionalPhone": optionalPhone,
      "details": details,
      "phone": phone,
      "checkDate": checkDate,
      "visitDate": visitDate,
      "userIsReceived": userIsReceived,
      "patientIsCame": patientIsCame,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "addressDetails": addressDetails,
      "type": type?.toMap(),
      "region": region?.toMap(),
      "shortUser": shortUser?.toMap(),
      "priority": priority?.toMap(),
      "reportlogs": reportlogs.toString(),
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  static List<Report> reportList(List data) =>
      data.map((report) => Report.fromMap(report)).toList();
  set setShortUser(ShortUser shortUser) => this.shortUser = shortUser;
}
