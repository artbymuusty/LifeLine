import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../providers/auth_provider.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _saving = false;
  bool wantsToHelp = false;
  bool locationPermission = true;
  String lastKnownLocation = ''; // "lat, lng" veya hata mesajı

  final TextEditingController nameController  = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _loadProfile();
  }

  Future<void> _loadLocation() async {
    try {
      final pos = await _determinePosition();
      setState(() {
        locationPermission = true;
        lastKnownLocation =
            '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
      });
    } catch (e) {
      setState(() {
        locationPermission = false;
        lastKnownLocation = 'Konum alınamadı';
      });
    }
  }

  Future<Position> _determinePosition() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        throw Exception('Konum izni reddedildi');
      }
    }
    if (perm == LocationPermission.deniedForever) {
      throw Exception('Konum izni kalıcı olarak devre dışı');
    }
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _loadProfile() async {
    try {
      final auth = context.read<AuthProvider>();
      final user = auth.currentUser!;
      final uri = Uri.parse('$kBaseUrl$kProfileEndpoint?userId=${user.id}');
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        setState(() {
          nameController.text  = data['name']  ?? '';
          phoneController.text = data['phone'] ?? '';
          emailController.text = data['email'] ?? '';
        });
      } else {
        debugPrint('Profil yükleme hatası ${resp.statusCode}: ${resp.body}');
      }
    } catch (e) {
      debugPrint('Profil yüklerken hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          IconButton(
            icon: _saving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.save),
            onPressed: _saving ? null : _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar ve isim
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/boy_icon.png'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Ad Soyad'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Telefon numarası: sadece rakam, en fazla 11 hane
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefon Numarası',
                helperText: 'Örnek "05321234567"',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
            ),
            const SizedBox(height: 16),

            // E-posta
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-posta Adresi'),
              keyboardType: TextInputType.emailAddress,
            ),
            const Divider(height: 32),

            // Konum bilgisi
            const Text(
              'Konum Bilgisi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on),
              title: Text(lastKnownLocation),
              subtitle: Text(
                locationPermission ? 'Konum erişimi açık' : 'Konum erişimi kapalı',
              ),
            ),
            const Divider(height: 32),

            // Gönüllü olma tercihi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Gönüllü Olmak İstiyorum', style: TextStyle(fontSize: 16)),
                Switch(
                  value: wantsToHelp,
                  onChanged: (v) => setState(() => wantsToHelp = v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    setState(() => _saving = true);
    try {
      final auth = context.read<AuthProvider>();
      final user = auth.currentUser!;
      final uri = Uri.parse('$kBaseUrl$kProfileEndpoint');
      final body = {
        'userId': user.id,
        'name'  : nameController.text.trim(),
        'phone' : phoneController.text.trim(),
        'email' : emailController.text.trim(),
      };
      final resp = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil başarıyla güncellendi')),
        );
      } else {
        throw Exception('Sunucu hatası ${resp.statusCode}: ${resp.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e'), duration: const Duration(seconds: 5)),
      );
    } finally {
      setState(() => _saving = false);
    }
  }
}
