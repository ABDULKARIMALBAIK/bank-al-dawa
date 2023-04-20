import 'package:bank_al_dawa/app/core/models/report_models/report_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TypeModel {
  TypeModel({
    required this.id,
    required this.name,
  });
  @Id(assignable: true)
  final int id;
  final String name;
  @Backlink('typeModelRelation')
  final ToMany<Report> reports = ToMany<Report>();
  factory TypeModel.fromMap(Map<String, dynamic> json) => TypeModel(
        id: int.parse(json["id"]),
        name: json["name"],
      );
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
