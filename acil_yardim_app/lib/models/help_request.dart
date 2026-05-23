// lib/models/help_request.dart

import '../models/user.dart';

class HelpRequest {
  final int? id;
  final String kitType;
  final int userId;
  final User? user;
  final double lat;
  final double lng;
  final DateTime timestamp;

  HelpRequest({
    this.id,
    required this.kitType,
    required this.userId,
    this.user,
    required this.lat,
    required this.lng,
    required this.timestamp,
  });

  /// factory to parse HelpRequest from JSON securely
  factory HelpRequest.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] as num?)?.toInt();
    final kitType = (json['kitType'] ?? json['kit_type']) as String? ?? '';

    final userJson = json['user'] as Map<String, dynamic>?;
    final userId = userJson != null
        ? (userJson['id'] as num?)?.toInt() ?? 0
        : (json['user_id'] as num?)?.toInt() ?? 0;

    final user = userJson != null ? User.fromJson(userJson) : null;

    // Supports both flat lat/lng (from backend responses) and nested location maps
    final double lat = (json['lat'] as num?)?.toDouble() ??
        (json['location']?['lat'] as num?)?.toDouble() ??
        0.0;
    final double lng = (json['lng'] as num?)?.toDouble() ??
        (json['location']?['lng'] as num?)?.toDouble() ??
        0.0;

    DateTime timestamp = DateTime.now();
    final rawTs = json['timestamp'];
    if (rawTs != null) {
      if (rawTs is String) {
        timestamp = DateTime.parse(rawTs);
      } else if (rawTs is DateTime) {
        timestamp = rawTs;
      }
    }

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

  String get description => kitType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
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
