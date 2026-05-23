// lib/models/help_request.dart

import '../models/user.dart';

class HelpRequest {
  final int? id;           // artık nullable
  final String kitType;
  final int userId;
  final User? user;        // Nested user objesi varsa buraya gelir
  final double lat;
  final double lng;
  final DateTime timestamp;


  /// Yardım çağrısı modeli
  HelpRequest({
    this.id,               // artık required değil
    required this.kitType,
    required this.userId,
    this.user,
    required this.lat,
    required this.lng,
    required this.timestamp,
  });

  /// JSON'dan HelpRequest objesi oluşturur
  factory HelpRequest.fromJson(Map<String, dynamic> json) {
    // 1) id
    final id = (json['id'] as num?)?.toInt();

    // 2) kitType
    final kitType = (json['kitType'] ?? json['kit_type']) as String? ?? '';

    //  3) userId
    final userJson = json['user'] as Map<String, dynamic>?;
    final userId = userJson != null
        ? (userJson['id'] as num?)?.toInt() ?? 0
        : (json['user_id'] as num?)?.toInt() ?? 0;

    // 4) User objesi
    final user = userJson != null ? User.fromJson(userJson) : null;

    // 5) Lat / Lng
    final lat = (json['location']?['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (json['location']?['lng'] as num?)?.toDouble() ?? 0.0;

    // 6) Timestamp: 
    final rawTs = json['timestamp'];
    final  timestamp;
    if (rawTs is! String) {
      timestamp = rawTs is DateTime
            ? rawTs
            : DateTime.now();
    } else {
      timestamp = DateTime.parse(rawTs);
    }

    // 7) Tüm alanları kullanarak HelpRequest objesi oluştur
    return HelpRequest(
      id: id,
      kitType: kitType,
      userId: userId,
      user: user,
      lat: lat,
      lng: lng,
      timestamp: timestamp,
    );
  }

  /// Kısaca hangi kiti çağırdığınızı gösterir
  String get description => kitType;

  // Yardım çağrısını JSON formatına dönüştürür
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      // id sadece varsa gönderilsin
      if (id != null) 'id': id,
      'kitType': kitType,
      'user_id': userId,
      'location': {'lat': lat, 'lng': lng},
      'timestamp': timestamp.toIso8601String(),
    };
    if (user != null) {
      map['user'] = user!.toJson();
    }
    return map;
  }
}
