import 'core/core.dart';
import 'enums/enums.dart';
import 'interfaces/interfaces.dart';
import 'logger/logger.dart';

class ChampVideo {
  static ChampStatus status = ChampStatus.unknown;
  static bool isSafeOpened = false;
  static Future<ChampStatus> initialize({
    required String connectToken,
    String? deviceToken,
    bool isProd = false,
  }) async {
    try {
      Logger.enabled = !isProd;

      await SecureVault.setToken(connectToken);
      if (deviceToken != null && deviceToken.isNotEmpty) {
        await ChampService.saveDeviceToken(deviceToken);
      }
      status = ChampStatus.ready;
      return status;
    } catch (err) {
      Logger.debug(err);
      status = ChampStatus.error;
      return status;
    }
  }

  static Future<String> localUserId() async => await SecureVault.localUserId();

  static Future<CallSession?> call({
    required String toId,
    required Caller caller,
    bool audioOnly = true,
  }) async {
    try {
      Call _call = await ChampService.createCall(
        toId,
        caller: caller,
        audioOnly: audioOnly,
      );
      CallSession _session = CallSession();
      await _session.connect(
        callId: _call.id,
        token: _call.token,
      );
      return _session;
    } catch (err) {
      rethrow;
    }
  }

  static Future<CallSession?> answer({required String callId}) async {
    try {
      Call _call = await ChampService.answer(callId);
      CallSession _session = CallSession();
      await _session.connect(
        callId: _call.id,
        token: _call.token,
      );
      return _session;
    } catch (err) {
      rethrow;
    }
  }

  static Future<ResponseStatus> decline({
    required String callId,
    String? reason,
  }) async {
    try {
      ResponseStatus _status = await ChampService.decline(
        callId,
        reason: reason,
      );
      return _status;
    } catch (err) {
      rethrow;
    }
  }

  static Future<ResponseStatus> endCall({
    required String callId,
    String? reason,
  }) async {
    try {
      ResponseStatus _status = await ChampService.endCall(
        callId,
        reason: reason,
      );
      return _status;
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> logout() async {
    await SecureVault.clear();
    return;
  }

  static Future<ResponseStatus> addParticipant({
    required String toId,
    required String callId,
    required Caller caller,
    bool audioOnly = true,
  }) async {
    try {
      ResponseStatus _status = await ChampService.addParticipant(
        toId,
        callId: callId,
        caller: caller,
        audioOnly: audioOnly,
      );

      return _status;
    } catch (err) {
      rethrow;
    }
  }
}
