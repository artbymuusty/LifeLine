// lib/providers/help_request_provider.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../models/help_request.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

/// Uygulamanın "Yardım Çağrısı" işlevselliğini yöneten provider.
class HelpRequestProvider extends ChangeNotifier {
  String? _selectedKit;
  bool isLoading = false;
  String? lastError;
  final List<HelpRequest> _requests = [];

  List<HelpRequest> get requests => List.unmodifiable(_requests);
  String? get selectedKit => _selectedKit;

  set selectedKit(String? kit) {
    _selectedKit = kit;
    notifyListeners();
  }

  /// Yeni bir yardım çağrısı oluşturur.
  /// Seçili kit, koordinatlar ve zaman damgasıyla bir HelpRequest inşa
  /// eder, API üzerinden gönderir ve listeye ekler.
  Future<void> sendRequest(BuildContext context) async {
    if (_selectedKit == null) {
      lastError = 'Lütfen bir çanta seçin.';
      notifyListeners();
      return;
    }

    _setLoading(true);

    try {
      // 1️⃣ Kullanıcı ve token bilgilerini al
      final auth = context.read<AuthProvider>();
      final user = auth.currentUser!;
      final token = auth.token!;

      // 2️⃣ Cihaz konumunu edin
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3️⃣ Yardım çağrısı modelini oluştur
      final newRequest = HelpRequest(
        id: null,
        kitType: _selectedKit!,
        userId: user.id!,                   // currentUser.id nullable olabilir; ! ile garanti ettik
        user: user,
        lat: position.latitude,
        lng: position.longitude,
        timestamp: DateTime.now(),
      );

      // 4️⃣ API aracılığıyla sunucuya gönder
      await ApiService.sendHelpRequest(newRequest, token);

      // 5️⃣ Başarılıysa listeye başa ekle
      _requests.insert(0, newRequest);
      lastError = null;
    } catch (error) {
      // Hata mesajını yakala ve göster
      lastError = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Sunucudan mevcut yardım çağrılarını çeker ve listeyi günceller.
  Future<void> fetchRequests(BuildContext context) async {
    _setLoading(true);

    try {
      final token = context.read<AuthProvider>().token!;
      final list = await ApiService.fetchHelpRequests(token);

      _requests
        ..clear()
        ..addAll(list);

      lastError = null;
    } catch (error) {
      lastError = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// İç durumun yükleniyor olup olmadığını ve hata bilgisini sıfırlar.
  void _setLoading(bool value) {
    isLoading = value;
    if (value) {
      // Yeni bir işlem başladığında önceki hataları temizle
      lastError = null;
    }
    notifyListeners();
  }
}
