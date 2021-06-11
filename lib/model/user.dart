import 'package:slark/model/Workspace.dart';
import 'package:slark/model/role.dart';

class User {
  User({
    this.verified,
    this.workspaces,
    this.tasks,
    this.roles,
    this.id,
    this.name,
    this.email,
  });

  bool verified;
  List<Workspace> workspaces;
  List<dynamic> tasks;
  List<Role> roles;
  String id;
  String name;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        verified: json["verified"],
        workspaces: List<Workspace>.from(
            json["_workspaces"].map((x) => Workspace.fromJson(x))),
        tasks: List<dynamic>.from(json["_tasks"].map((x) => x)),
        roles: List<Role>.from(json["_roles"].map((x) => Role.fromJson(x))),
        id: json["_id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "verified": verified,
        "_workspaces": List<dynamic>.from(workspaces.map((x) => x.toJson())),
        "_tasks": List<dynamic>.from(tasks.map((x) => x)),
        "_roles": List<dynamic>.from(roles.map((x) => x.toJson())),
        "_id": id,
        "name": name,
        "email": email,
      };
}
