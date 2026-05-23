// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/help_request.dart';

/// Centralized API Service for all networking communications
class ApiService {
  /// User authentication login request. Returns data payload containing token and user info.
  static Future<Map<String, dynamic>> login({
    required String tc,
    required String password,
  }) async {
    final url = Uri.parse('$kBaseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'tc': tc, 'password': password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['success'] == true && body['data'] != null) {
        return body['data'] as Map<String, dynamic>;
      }
      throw Exception(body['message'] ?? 'Giriş başarısız.');
    } else {
      String errMsg = 'Giriş başarısız.';
      try {
        final body = jsonDecode(response.body);
        errMsg = body['message'] ?? errMsg;
      } catch (_) {}
      throw Exception('$errMsg (Kod: ${response.statusCode})');
    }
  }

  /// Sends a new emergency help request.
  static Future<void> sendHelpRequest({
    required String kitType,
    required double lat,
    required double lng,
    required String timestamp,
    required String token,
    List<String> selectedItems = const [],
  }) async {
    final url = Uri.parse('$kBaseUrl$kHelpRequestEndpoint');
    final body = {
      'kitType': kitType,
      'lat': lat,
      'lng': lng,
      'timestamp': timestamp,
      if (selectedItems.isNotEmpty) 'selectedItems': selectedItems,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      String errMsg = 'Yardım çağrısı gönderilemedi.';
      try {
        final body = jsonDecode(response.body);
        errMsg = body['message'] ?? errMsg;
      } catch (_) {}
      throw Exception('$errMsg (Kod: ${response.statusCode})');
    }
  }

  /// Retrieves emergency help request logs (Restricted: Responders/Admins only)
  static Future<List<HelpRequest>> fetchHelpRequests(String token) async {
    final url = Uri.parse('$kBaseUrl$kHelpRequestEndpoint');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final list = body['data'] as List<dynamic>? ?? [];
      return list.map((e) => HelpRequest.fromJson(e)).toList();
    } else {
      String errMsg = 'Geçmiş çağrılar alınamadı.';
      try {
        final body = jsonDecode(response.body);
        errMsg = body['message'] ?? errMsg;
      } catch (_) {}
      throw Exception('$errMsg (Kod: ${response.statusCode})');
    }
  }

  /// Fetches the profile details of the authenticated user
  static Future<Map<String, dynamic>> fetchProfile(String token) async {
    final url = Uri.parse('$kBaseUrl$kProfileEndpoint');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['success'] == true && body['data'] != null) {
        return body['data'] as Map<String, dynamic>;
      }
      throw Exception(body['message'] ?? 'Profil bilgileri alınamadı.');
    } else {
      String errMsg = 'Profil yüklenemedi.';
      try {
        final body = jsonDecode(response.body);
        errMsg = body['message'] ?? errMsg;
      } catch (_) {}
      throw Exception('$errMsg (Kod: ${response.statusCode})');
    }
  }

  /// Updates the profile details of the authenticated user
  static Future<void> updateProfile({
    required String token,
    required String name,
    required String phone,
    required String email,
  }) async {
    final url = Uri.parse('$kBaseUrl$kProfileEndpoint');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'email': email,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      String errMsg = 'Profil güncellenemedi.';
      try {
        final body = jsonDecode(response.body);
        errMsg = body['message'] ?? errMsg;
      } catch (_) {}
      throw Exception('$errMsg (Kod: ${response.statusCode})');
    }
  }
}
