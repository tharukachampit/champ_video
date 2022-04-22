import 'dart:convert';
import 'dart:io';

import 'package:champ_video/src/enums/enums.dart';
import 'package:champ_video/src/interfaces/interfaces.dart';
import 'package:champ_video/src/logger/logger.dart';
import 'package:http/http.dart' as http;

import 'core.dart';

class ChampService {
  static Future<void> saveDeviceToken(deviceToken) async {
    String? token = await SecureVault.getToken();
    String? baseUrl = await SecureVault.baseUrl();

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    http.Response response = await http.post(
      Uri.parse('$baseUrl/api/device'),
      headers: headers,
      body: json.encode({
        "deviceToken": "$deviceToken",
        "platform": Platform.operatingSystem,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Logger.debug(response.body);
    } else {
      Logger.debug(response.reasonPhrase);
    }
  }

  static Future<Call> createCall(
    String to, {
    required Caller caller,
    bool audioOnly = true,
  }) async {
    String? token = await SecureVault.getToken();
    String? baseUrl = await SecureVault.baseUrl();

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    http.Response response = await http.post(
      Uri.parse('$baseUrl/api/calls'),
      headers: headers,
      body: json.encode({
        "to": to,
        "payload": {
          "callerName": caller.callerName,
          "photoUrl": caller.photoUrl,
        },
        "audioOnly": audioOnly
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Logger.debug(response.body);
      return Call.fromRawJson(response.body);
    } else {
      Logger.debug(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<Call> answer(String callId) async {
    String? token = await SecureVault.getToken();
    String? baseUrl = await SecureVault.baseUrl();

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    http.Response response = await http.post(
      Uri.parse('$baseUrl/api/calls/$callId/answer'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Logger.debug(response.body);
      return Call.fromRawJson(response.body);
    } else {
      Logger.debug(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<ResponseStatus> decline(String callId, {String? reason}) async {
    String? token = await SecureVault.getToken();
    String? baseUrl = await SecureVault.baseUrl();

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    http.Response response = await http.post(
      Uri.parse('$baseUrl/api/calls/$callId/decline'),
      headers: headers,
      body: json.encode({"reason": reason}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Logger.debug(response.body);
      return ResponseStatus.success;
    } else {
      Logger.debug(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<ResponseStatus> endCall(String callId, {String? reason}) async {
    String? token = await SecureVault.getToken();
    String? baseUrl = await SecureVault.baseUrl();

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    http.Response response = await http.post(
      Uri.parse('$baseUrl/api/calls/$callId/end'),
      headers: headers,
      body: json.encode({"reason": reason}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Logger.debug(response.body);
      return ResponseStatus.success;
    } else {
      Logger.debug(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<ResponseStatus> addParticipant(
    String to, {
    required String callId,
    required Caller caller,
    bool audioOnly = true,
  }) async {
    String? token = await SecureVault.getToken();
    String? baseUrl = await SecureVault.baseUrl();

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    http.Response response = await http.post(
      Uri.parse('$baseUrl/api/calls/$callId/participants'),
      headers: headers,
      body: json.encode({
        "to": to,
        "payload": {
          "callerName": caller.callerName,
          "photoUrl": caller.photoUrl,
        },
        "audioOnly": audioOnly
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Logger.debug(response.body);
      return ResponseStatus.success;
    } else {
      Logger.debug(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<String> getToken({
    required String id,
    required String url,
    required String apiKey,
  }) async {
    Map<String, String> headers = {
      'X-API-KEY': apiKey,
      'Content-Type': 'application/json',
    };

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode({
        "id": id,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Logger.debug(response.body);
      return response.body;
    } else {
      Logger.debug(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }
}
