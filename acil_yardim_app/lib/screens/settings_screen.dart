// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'change_password_screen.dart';
import 'call_history_screen.dart';
import 'faq_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void showFontSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Yazı Boyutu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Burada font büyüklüğünü ayarlayabilirsiniz.'),
            // Örnek slider:
            // Slider(
            //   min: 12,
            //   max: 30,
            //   value: /* mevcut boyut değeri */,
            //   onChanged: (v) {},
            // ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final packageInfo = Provider.of<PackageInfo>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          const SettingsSectionHeader('Hesap'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Şifre Değiştir'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Oturumu Kapat'),
            onTap: () => context.read<AuthProvider>().logout(),
          ),

          const SettingsSectionHeader('Görünüm & Erişilebilirlik'),
          ListTile(
            leading: const Icon(Icons.format_size),
            title: const Text('Yazı Boyutu'),
            onTap: () => showFontSizeDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Tema'),
            trailing: Switch(
              value: context.watch<ThemeProvider>().isDarkMode,
              onChanged: (value) => context.read<ThemeProvider>().toggleTheme(value),
            ),
          ),

          const SettingsSectionHeader('Çağrı Geçmişi'),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Gönderilen Çağrılar'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CallHistoryScreen()),
            ),
          ),

          const SettingsSectionHeader('Yardım & Hakkında'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('SSS'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FaqScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Versiyon Bilgisi'),
            subtitle: Text(packageInfo.version),
          ),
        ],
      ),
    );
  }
}

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  const SettingsSectionHeader(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: style),
    );
  }
}
  