import 'dart:convert';
import 'dart:io';

import 'package:champ_video/src/logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path_provider/path_provider.dart';

class SecureVault {
  static const _storage = FlutterSecureStorage();
  static const String _tokenKey = 'token';
  static String _token = '';

  static const String _userIdKey = 'id';
  static const String _userKey = 'cc_id';
  static String _userId = '';

  static const String _baseUrlKey = 'base_url';
  static String _baseUrl = '';

  static const String _liveUrlKey = 'live_url';
  static String _liveUrl = '';

  static Future<String> getToken() async {
    if (_token.isNotEmpty) {
      return _token;
    }
    _token = await _storage.read(key: _tokenKey) ?? '';
    return _token;
  }

  static Future<String> baseUrl() async {
    if (_baseUrl.isNotEmpty) {
      return _baseUrl;
    }
    _baseUrl = await _storage.read(key: _baseUrlKey) ?? '';
    _liveUrl = await _storage.read(key: _liveUrlKey) ?? '';
    _userId = await _storage.read(key: _userKey) ?? '';
    _token = await _storage.read(key: _tokenKey) ?? '';
    return _baseUrl;
  }

  static Future<String> liveUrl() async {
    if (_liveUrl.isNotEmpty) {
      return _liveUrl;
    }
    _liveUrl = await _storage.read(key: _liveUrlKey) ?? '';
    return _liveUrl;
  }

  static Future<String> localUserId() async {
    if (_userId.isNotEmpty) {
      return _userId;
    }
    _userId = await _storage.read(key: _userKey) ?? '';
    return _liveUrl;
  }

  static Future<void> setToken(String token) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    Map<String, dynamic> userToken = JwtDecoder.decode(decodedToken[_tokenKey]);
    await _storage.write(key: _baseUrlKey, value: decodedToken[_baseUrlKey]);

    await _storage.write(key: _userKey, value: userToken[_userIdKey]);

    await _storage.write(key: _liveUrlKey, value: decodedToken[_liveUrlKey]);
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<void> clear() async {
    _token = '';
    _userId = '';
    _baseUrl = '';
    _liveUrl = '';
    await _storage.deleteAll();
  }
}
