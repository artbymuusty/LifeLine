// lib/utils/constants.dart

import 'package:flutter/material.dart';

/// API’nin kök adresi - dart-define ile dışarıdan alınır, varsayılan olarak yerel emülatör kullanılır.
/// Çalıştırma örneği: flutter run --dart-define=API_BASE_URL=http://localhost:3000
const String kBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:3000',
);

/// Yardım çağrıları endpoint’i
const String kHelpRequestEndpoint = '/help_requests';

/// Profil güncelleme endpoint'i
const String kProfileEndpoint = '/user/profile';

/// Uygulamanın vurgu rengi
const kAccentColor = Colors.redAccent;