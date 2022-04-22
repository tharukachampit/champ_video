import 'dart:async';
import 'dart:collection';

import 'dart:ui';

import 'package:champ_video/src/core/core.dart';
import 'package:champ_video/src/enums/enums.dart';
import 'package:champ_video/src/interfaces/interfaces.dart';
import 'package:champ_video/src/interfaces/server_events.dart';
import 'package:champ_video/src/logger/logger.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class CallSession {
  late Room session;
  Socket? _socket;
  bool initialized = false;

  StreamSubscription? sseStream;

  final StreamController<RoomEvent> _eventsStream =
      StreamController<RoomEvent>.broadcast();

  Stream<RoomEvent> get eventsStream => _eventsStream.stream;

  LocalParticipant? get localParticipant => session.localParticipant;
  UnmodifiableMapView<String, RemoteParticipant>? get remoteParticipant =>
      session.participants;

  late final EventsListener<RoomEvent> _listener;
  String callId = '';

  Map<String, dynamic> _socketOption(String token, String callId) {
    return OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setPath('/connect')
        .setAuth({'withCredentials': true})
        .setExtraHeaders({'Authorization': 'Bearer $token'})
        .setQuery({"callId": callId})
        .enableForceNewConnection()
        .build();
  }

  Future<void> connect({
    required String callId,
    required String token,
  }) async {
    try {
      String sseUrl = await SecureVault.baseUrl();
      String ccToken = await SecureVault.getToken();
      this.callId = callId;
      _socket = io(sseUrl, _socketOption(ccToken, callId));
      _socket?.onConnect((data) {
        _socket?.emit('auth', 'login');
      });
      _socket?.on('message', (data) {
        if (data != null) {
          _handleServerMessage(ServerMessage.fromRawJson(data!));
        }
      });
      _socket?.connect();

      session = await LiveKitClient.connect(
        await SecureVault.liveUrl(),
        token,
        connectOptions: const ConnectOptions(
          autoSubscribe: true,
        ),
        roomOptions: const RoomOptions(
          defaultVideoPublishOptions: VideoPublishOptions(
            simulcast: true,
          ),
        ),
      );
      _listener = session.createListener();
      _listener.on<RoomEvent>(_onRoomEvent);
      initialized = true;
    } catch (err) {
      Logger.debug(err);
      initialized = false;
    }
  }

  void _onRoomEvent(RoomEvent event) {
    _eventsStream.add(event);
  }

  void _handleServerMessage(ServerMessage message) {
    switch (message.type) {
      case ServerEvent.callStatus:
        if (initialized) {
          _eventsStream.add(CallStatusUpdated(message.call!));
        }
        break;
      case ServerEvent.userDeclined:
        if (initialized) {
          _eventsStream.add(CallDeclined(message.user!, message.call!));
        }
        break;
      case ServerEvent.userLeft:
        if (initialized) {
          _eventsStream.add(UserLeft(message.user!, message.call!));
        }
        break;
      case ServerEvent.userJoined:
        if (initialized) {
          _eventsStream.add(UserConnecting(message.user!, message.call!));
        }
        break;
      case ServerEvent.participantAdded:
        if (initialized) {
          _eventsStream.add(CallingToAddedUser(message.user!, message.call!));
        }
        break;
      case ServerEvent.participantNoAnswer:
        if (initialized) {
          _eventsStream.add(AddedUserNoAnswer(message.user!, message.call!));
        }
        break;
      default:
        Logger.debug(message.toJson());
        break;
    }
  }

  dispose() async {
    if (initialized) {
      initialized = false;
      await session.disconnect();
      await session.dispose();
      _socket?.disconnect();
      _socket?.close();
      _socket?.destroy();
      _listener.cancelAll();
      _eventsStream.close();
    }
    sseStream?.cancel();
  }
}
