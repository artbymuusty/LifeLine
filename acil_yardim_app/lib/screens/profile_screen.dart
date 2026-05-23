import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/api_service.dart';
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
  String lastKnownLocation = ''; // "lat, lng" or error message

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _loadProfile();
  }

  // Retrieve current location safely showing fallback on error
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

  // Fetch profile via ApiService using Bearer Token
  Future<void> _loadProfile() async {
    try {
      final auth = context.read<AuthProvider>();
      final token = auth.token;
      if (token == null) return;

      final data = await ApiService.fetchProfile(token);
      setState(() {
        nameController.text = data['name'] ?? '';
        phoneController.text = data['phone'] ?? '';
        emailController.text = data['email'] ?? '';
      });
    } catch (e) {
      debugPrint('Profil yüklerken hata: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil yüklenemedi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-posta Adresi'),
              keyboardType: TextInputType.emailAddress,
            ),
            const Divider(height: 32),
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
                locationPermission
                    ? 'Konum erişimi açık'
                    : 'Konum erişimi kapalı',
              ),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Gönüllü Olmak İstiyorum',
                    style: TextStyle(fontSize: 16)),
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

  // Save profile updates via ApiService using Bearer Token
  Future<void> _saveProfile() async {
    setState(() => _saving = true);
    try {
      final auth = context.read<AuthProvider>();
      final token = auth.token;
      if (token == null) throw Exception('Yetkilendirme anahtarı bulunamadı.');

      await ApiService.updateProfile(
        token: token,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil başarıyla güncellendi.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Hata: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
