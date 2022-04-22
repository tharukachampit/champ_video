import 'dart:convert';

class ChampUser {
  ChampUser({
    required this.role,
    required this.username,
    required this.email,
    required this.name,
    required this.id,
    required this.organization,
  });

  final String? role;
  final String? username;
  final String? email;
  final String? name;
  final String? id;
  final String? organization;

  ChampUser copyWith({
    String? role,
    String? username,
    String? email,
    String? name,
    String? id,
    String? organization,
  }) =>
      ChampUser(
        role: role ?? this.role,
        username: username ?? this.username,
        email: email ?? this.email,
        name: name ?? this.name,
        id: id ?? this.id,
        organization: organization ?? this.organization,
      );

  factory ChampUser.fromRawJson(String str) =>
      ChampUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChampUser.fromJson(Map<String, dynamic> json) => ChampUser(
        role: json["role"],
        username: json["username"],
        email: json["email"],
        name: json["name"],
        id: json["id"],
        organization: json["organization"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "username": username,
        "email": email,
        "name": name,
        "id": id,
        "organization": organization,
      };
}
