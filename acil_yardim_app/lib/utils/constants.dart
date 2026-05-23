// lib/utils/constants.dart

import 'package:flutter/material.dart';

/// API’nin kök adresi
/// - Web için `localhost`
/// - Android emülatör için `10.0.2.2`
/// - Gerçek cihaz için backend’in IP adresi
// const String kBaseUrl = 'http://localhost:3000';
// Gerçek telefon kullanıyorsan (örneğin PC’in IP’si 192.168.1.42 ise):


const kBaseUrl = 'http://192.168.1.103:3000';


/// Yardım çağrıları endpoint’i
const String kHelpRequestEndpoint = '/help_requests';

/// Uygulamanın vurgu rengi
const kAccentColor = Colors.redAccent;

// Profil güncelleme için yeni bir sabit ekleyelim:
const String kProfileEndpoint = '/user/profile'; 