// lib/providers/help_request_provider.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../models/help_request.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

/// Provider managing emergency help request operations and state
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

  /// Sends a new emergency help request through the centralized ApiService.
  Future<bool> sendRequest(BuildContext context, {List<String> selectedItems = const []}) async {
    if (_selectedKit == null) {
      lastError = 'Lütfen bir çanta seçin.';
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      final auth = context.read<AuthProvider>();
      final user = auth.currentUser!;
      final token = auth.token!;

      // 1. Retrieve the high accuracy GPS coordinates
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final ts = DateTime.now().toUtc().toIso8601String();

      // 2. Call Refactored API Service
      await ApiService.sendHelpRequest(
        kitType: _selectedKit!,
        lat: position.latitude,
        lng: position.longitude,
        timestamp: ts,
        token: token,
        selectedItems: selectedItems,
      );

      // 3. Insert local success representation to top of list
      final newRequest = HelpRequest(
        id: null,
        kitType: _selectedKit!,
        userId: user.id ?? 0,
        user: user,
        lat: position.latitude,
        lng: position.longitude,
        timestamp: DateTime.now(),
      );
      _requests.insert(0, newRequest);
      
      lastError = null;
      _setLoading(false);
      return true;
    } catch (error) {
      lastError = error.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  /// Pulls the existing help requests from backend (restricted)
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
      lastError = error.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    if (value) {
      lastError = null;
    }
    notifyListeners();
  }
}
