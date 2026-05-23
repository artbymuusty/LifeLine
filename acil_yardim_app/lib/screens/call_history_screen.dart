// lib/screens/call_history_screen.dart

import 'package:flutter/material.dart';

class CallHistoryScreen extends StatelessWidget {
  const CallHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Gerçek veriyi SQL veya local DB’den çekin
    final dummy = <String>['Çağrı 1', 'Çağrı 2', 'Çağrı 3'];

    return Scaffold(
      appBar: AppBar(title: const Text('Çağrı Geçmişi')),
      body: ListView.separated(
        itemCount: dummy.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.call_made),
          title: Text(dummy[i]),
          subtitle: const Text('19 Mayıs 2025 - 13:00'),
        ),
      ),
    );
  }
}
