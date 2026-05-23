// lib/screens/login_screen.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _tcController = TextEditingController();
  final _pwdController = TextEditingController();
  bool _keepLoggedIn = false;
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                 'Life Line+',
                 style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                   // işte buraya indirdiğin fontun family adını veriyorsun:
                   fontFamily: 'Augustus',
                   fontSize: 32,
                   fontWeight: FontWeight.bold,
                  ),
                  

                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _tcController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'TC Kimlik No',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _pwdController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: _keepLoggedIn,
                  onChanged: (v) => setState(() => _keepLoggedIn = v!),
                  title: const Text('Hesabımı Açık Tut'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentColor,
                    ),
                    onPressed: _isLoading ? null : () async {
                      setState(() {
                        _isLoading = true;
                        _error = null;
                      });

                      final tc  = _tcController.text.trim();
                      final pwd = _pwdController.text;

                      try {
                        // 1️⃣ Ham Map’i al
                        final result = await ApiService.login(
                          tc: tc,
                          password: pwd,
                        );

                        // 2️⃣ Konsola basıp JSON yapısını görün
                        print('LOGIN RESULT MAP → $result');

                        // 3️⃣ JSON yapınıza göre token ve userMap’i ayıklayın:
                        // Örnek A) Düz dönüyorsa: { "token": "...", "user": { ... } }
                        final token = result['token'] as String;
                        final userMap = result['user'] as Map<String, dynamic>;

                        // Örnek B) Eğer { "data": { "token": "...", "user": { ... } } } dönüyorsa:
                        // final data = result['data'] as Map<String, dynamic>;
                        // final token = data['token'] as String;
                        // final userMap = data['user'] as Map<String, dynamic>;

                        // 4️⃣ User modelini oluştur
                        final user = User.fromJson(userMap);

                        // 5️⃣ Sağlayıcıya login bilgilerini ilet
                        await auth.login(token, user);

                        // 6️⃣ 'Hesabımı Açık Tut' varsa ayrıca prefs’e kaydet
                        if (_keepLoggedIn) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('jwt_token', token);
                        }

                        // 7️⃣ Ana ekrana yönlendir
                        if (!mounted) return;
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );

                      } catch (e) {
                        setState(() {
                          _error = 'Giriş hatası:\n${e.toString()}';
                        });
                      } finally {
                        if (mounted) setState(() => _isLoading = false);
                      }
                    },
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Giriş Yap'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    // TODO: kayıt ekranına yönlendir
                  },
                  child: const Text('Kayıt Ol'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
