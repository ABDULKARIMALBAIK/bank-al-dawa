import 'package:bank_al_dawa/app/core/models/user_models/user_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class PermissionModel {
  PermissionModel({
    required this.id,
    required this.name,
  });
  @Id(assignable: true)
  final int id;
  final String name;
  @Backlink('permissionRelation')
  final ToMany<User> users = ToMany<User>();
  factory PermissionModel.fromMap(Map<String, dynamic> json) => PermissionModel(
        id: int.parse(json["id"]),
        name: json["name"],
      );
  @override
  String toString() {
    return '''
    id:$id,
    name:$name,
    ''';
  }
}
