import 'dart:convert';

import 'champ_user.dart';

class Call {
  Call({
    this.participants = const [],
    this.caller = '',
    this.audioOnly = true,
    this.isGroup = true,
    this.status = '',
    this.token = '',
    this.id = '',
    this.cancelReason = '',
  });

  final List<ChampUser> participants;
  final String caller;
  final bool audioOnly;
  final bool isGroup;
  final String status;
  final String token;
  final String id;
  final String cancelReason;

  Call copyWith({
    List<ChampUser>? participants,
    String? caller,
    bool? audioOnly,
    bool? isGroup,
    String? status,
    String? token,
    String? id,
    String? cancelReason,
  }) =>
      Call(
        participants: participants ?? this.participants,
        caller: caller ?? this.caller,
        audioOnly: audioOnly ?? this.audioOnly,
        isGroup: isGroup ?? this.isGroup,
        status: status ?? this.status,
        token: token ?? this.token,
        id: id ?? this.id,
        cancelReason: cancelReason ?? this.cancelReason,
      );

  factory Call.fromRawJson(String str) => Call.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Call.fromJson(Map<String, dynamic> json) => Call(
        participants: json["participants"] != null
            ? List<ChampUser>.from(
                json["participants"]?.map(
                  (x) => ChampUser.fromJson(x),
                ),
              )
            : [],
        caller: json["caller"] ?? '',
        audioOnly: json["audioOnly"] ?? false,
        isGroup: json["isGroup"] ?? false,
        status: json["status"],
        token: json["token"] ?? '',
        id: json["id"],
        cancelReason: json["cancelReason"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "participants": List<dynamic>.from(participants.map((x) => x.toJson())),
        "caller": caller,
        "audioOnly": audioOnly,
        "isGroup": isGroup,
        "status": status,
        "token": token,
        "id": id,
        "cancelReason": cancelReason,
      };
}
