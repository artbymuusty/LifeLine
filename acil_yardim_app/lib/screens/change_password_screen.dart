// lib/screens/change_password_screen.dart

import 'package:flutter/material.dart';



class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

// Şifre Değiştirme Ekranı
class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;


 // Ekran kapatıldığında temizleme işlemi
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Şifre Değiştir')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 8),
              ],
              TextFormField(
                controller: _oldController,
                decoration: const InputDecoration(labelText: 'Eski Şifre'),
                obscureText: true,
                validator: (v) => v == null || v.isEmpty ? 'Eski şifre girin' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newController,
                decoration: const InputDecoration(labelText: 'Yeni Şifre'),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Yeni şifre girin';
                  if (v == _oldController.text) return 'Yeni şifre eskiyle aynı olamaz';
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Şifre güncelleme işlemi
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // TODO: Burada API çağrısıyla şifreyi güncelleyin.
      await Future.delayed(const Duration(seconds: 1));

      // Örnek başarı:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifreniz başarıyla değiştirildi.')),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = 'Şifre değiştirilemedi: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
