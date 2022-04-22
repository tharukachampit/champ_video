import 'dart:convert';

import 'package:champ_video/src/enums/enums.dart';
import 'package:livekit_client/livekit_client.dart';

import 'interfaces.dart';

class RoomNotifyEvent implements RoomEvent {}

class CallStatusUpdated implements RoomEvent {
  final Call call;
  CallStatusUpdated(this.call);
}

class CallDeclined implements RoomEvent {
  final ChampUser user;
  final Call call;
  CallDeclined(this.user, this.call);
}

class UserConnecting implements RoomEvent {
  final ChampUser user;
  final Call call;

  UserConnecting(this.user, this.call);
}

class UserLeft implements RoomEvent {
  final ChampUser user;
  final Call call;

  UserLeft(this.user, this.call);
}

class CallingToAddedUser implements RoomEvent {
  final ChampUser user;
  final Call call;
  CallingToAddedUser(this.user, this.call);
}

class AddedUserNoAnswer implements RoomEvent {
  final ChampUser user;
  final Call call;
  AddedUserNoAnswer(this.user, this.call);
}

class ServerMessage {
  ServerMessage({
    this.type,
    this.user,
    this.call,
  });

  final ServerEvent? type;
  final ChampUser? user;
  final Call? call;

  ServerMessage copyWith({
    ServerEvent? type,
    ChampUser? user,
    Call? call,
  }) =>
      ServerMessage(
        type: type ?? this.type,
        user: user ?? this.user,
        call: call ?? this.call,
      );

  factory ServerMessage.fromRawJson(String str) =>
      ServerMessage.fromJson(jsonDecode(str));

  String toRawJson() => json.encode(toJson());

  factory ServerMessage.fromJson(Map<String, dynamic> json) {
    ServerEvent _type = ServerEvent.values
        .firstWhere((element) => element.index == json["type"]);
    return ServerMessage(
      type: _type,
      call: json["call"] != null ? Call.fromJson(json["call"]) : null,
      user: json["user"] != null ? ChampUser.fromJson(json["user"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "user": user?.toJson(),
        "call": call?.toJson(),
      };
}
