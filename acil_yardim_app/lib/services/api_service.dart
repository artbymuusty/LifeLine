// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/help_request.dart';

// API servis sınıfı, sunucu ile iletişim kurmak için gerekli HTTP isteklerini yapar.
class ApiService {
  /// TC/şifre ile giriş yapar, başarılıysa Map içinde hem token hem user verisini döner.
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

    // Debug için ham yanıtı konsola yazdırın
    print('LOGIN RESPONSE ➜ ${response.body}');

    if (response.statusCode == 200) {
      // JSON nesnesini Map olarak döndürün; parsing çağrı tarafında yapılacak
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // Hata mesajında gerçek kodu ve gövdeyi kullanın
      throw Exception(
        'Giriş başarısız: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Yeni bir yardım çağrısı gönderir.
  /// [hr] → gönderilecek çağrı objesi, [token] → Bearer token
  static Future<void> sendHelpRequest(HelpRequest hr, String token) async {
    final url = Uri.parse('$kBaseUrl$kHelpRequestEndpoint');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(hr.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Yardım çağrısı başarısız (${response.statusCode}): ${response.body}',
      );
    }
  }

  /// Sunucudan gelen tüm yardım çağrılarını çeker.
      static Future<List<HelpRequest>> fetchHelpRequests(String token) async {
        // DİKKAT: $kBaseUrl mutlaka port içermeli
        final url = Uri.parse('$kBaseUrl$kHelpRequestEndpoint?sort=timestamp');
        final response = await http.get(
          url,
          headers: { 'Authorization': 'Bearer $token' },
        );

    if (response.statusCode == 200) {
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => HelpRequest.fromJson(e)).toList();
  } else {
    throw Exception('Çağrılar alınamadı (${response.statusCode}): ${response.body}');
  }
  }
}
