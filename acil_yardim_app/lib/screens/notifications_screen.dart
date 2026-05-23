// lib/screens/notifications_screen.dart

import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications_active, color: Colors.red),
            title: const Text('Yeni güncelleme'),
            subtitle: const Text('Çantanıza yeni bir ürün eklendi!'),
            trailing: const Text('Şimdi'),
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.grey),
            title: const Text('Hatırlatma'),
            subtitle: const Text('Son kullanma tarihi yaklaşan ürünleriniz var.'),
            trailing: const Text('1 saat önce'),
          ),
        ],
      ),
    );
  }
}
