// lib/screens/faq_screen.dart
import 'package:flutter/material.dart';


// Sıkça Sorulan Sorular ekranı
class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final faqs = <Map<String, String>>[
      {'Soru: Nasıl yardım gönderebilirim?': 'Cevap: Ana ekranda kit seçip "Yardım Gönder" butonuna basın.'},
      {'Soru: Bildirimleri nereden açarım?': 'Cevap: Ayarlar > İzinler kısmından açabilirsiniz.'},
    ];

    // Eğer daha fazla soru eklemek istersen, buraya yeni map'ler ekleyebilirsin:
    return Scaffold(
      appBar: AppBar(title: const Text('Sıkça Sorulan Sorular')),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (ctx, i) {
          final qa = faqs[i].entries.first;
          return ExpansionTile(
            title: Text(qa.key, style: const TextStyle(fontWeight: FontWeight.bold)),
            children: [Padding(
              padding: const EdgeInsets.all(16),
              child: Text(qa.value),
            )],
          );
        },
      ),
    );
  }
}
