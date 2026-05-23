import 'package:flutter/material.dart';

// Bilgilendirme ekranı
class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Öneriler ve Bilgilendirme'),
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Bölüm 1
          const Text(
            '1. Alerjik Reaksiyonlar İçin Temel Ürünler',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('• EpiPen (Oto-enjektör)', style: TextStyle(fontSize: 14)),
          const Text('  Kullanım amacı: Anafilaksi gibi hayatı tehdit eden ciddi alerjik reaksiyonlarda ilk müdahale.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  Uygulama şekli: Kas içi (uyluk) enjeksiyon.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  Olası yan etkiler: Enjeksiyon bölgesinde ağrı, çarpıntı, terleme.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  SKT (Raf Ömrü): 12–18 ay', style: TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 8),
          const Text('• Antihistaminik (Tablet/Süspansiyon)', style: TextStyle(fontSize: 14)),
          const Text('  Kullanım amacı: Hafif–orta şiddette alerjik reaksiyonlar, kaşıntı ve döküntü kontrolü.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  Olası yan etkiler: Uyku hali, ağız kuruluğu.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  SKT: Ortalama 24 ay', style: TextStyle(fontSize: 14, height: 1.4)),
          const Divider(height: 32),

          // Bölüm 2
          const Text(
            '2. Ağrı ve Ateş Yönetimi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('• Parasetamol (Tablet/Süspansiyon)', style: TextStyle(fontSize: 14)),
          const Text('  Kullanım amacı: Ateş düşürücü ve hafif–orta şiddette ağrı kesici.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  Olası yan etkiler: Yüksek dozda karaciğer yükü.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  SKT: 24–36 ay', style: TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 8),
          const Text('• İbuprofen (Tablet/Süspansiyon)', style: TextStyle(fontSize: 14)),
          const Text('  Kullanım amacı: Ağrı kesici ve anti-inflamatuvar (iltihap giderici).', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  Olası yan etkiler: Mide tahrişi, reflü, nadiren alerjik reaksiyon.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  SKT: 24–36 ay', style: TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 8),
          const Text('• Deksketoprofen (Tablet)', style: TextStyle(fontSize: 14)),
          const Text('  Kullanım amacı: Güçlü ağrı kesici (şiddetli ağrılarda).', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  SKT: 24–36 ay', style: TextStyle(fontSize: 14, height: 1.4)),
          const Divider(height: 32),

          // Bölüm 3
          const Text(
            '3. Yara ve Enfeksiyon Bakımı',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('• Antiseptik Solüsyon', style: TextStyle(fontSize: 14)),
          const Text('  Kullanım amacı: Kesik, sıyrık ve yanık kenarlarının dezenfeksiyonu.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  Uygulama: Haricen, temiz gazlı bezle.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  SKT: 24 ay', style: TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 8),
          const Text('• Antibiyotikli Krem (Fusidin vb.)', style: TextStyle(fontSize: 14)),
          const Text('  Kullanım amacı: Enfekte olma riski yüksek yaralarda bakteri üremesini engelleme.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  SKT: 12–24 ay', style: TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 8),
          const Text('• Yanık Kremi (Silverdin)', style: TextStyle(fontSize: 14)),
          const Text('  Kullanım amacı: Yanık alanlarına bakım ve enfeksiyon önleme.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  SKT: 12–24 ay', style: TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 8),
          const Text('• Yara Bandı & Steril Gaz Bezi', style: TextStyle(fontSize: 14)),
          const Text('  Kullanım amacı: Kanamayı durdurma ve yara koruması.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  Ağırlık: Yara bandı ~5 g; gaz bezi ~10 g.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Divider(height: 32),

          // Bölüm 4
          const Text(
            '4. Sıvı ve Sindirim Desteği',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('• ORS (Oral Rehidratasyon Tuzu)', style: TextStyle(fontSize: 14)),
          const Text('  Kullanım amacı: İshal/kusma sonrası vücudun sıvı-elektrolit dengesini koruma.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  Form: Toz, 1 saşe ≈ 15 g', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  SKT: 24 ay', style: TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 8),
          const Text('• Anti-işhal İlacı (Loperamid)', style: TextStyle(fontSize: 14)),
          const Text('  Kullanım amacı: Şiddetli ishal semptomlarını kontrol altına alma.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  SKT: 24 ay', style: TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 8),
          const Text('• Spazm Çözücü (Buscopan)', style: TextStyle(fontSize: 14)),
          const Text('  Kullanım amacı: Karın ağrısı ve kramp giderme.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  SKT: 24 ay', style: TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 8),
          const Text('• Dramamin', style: TextStyle(fontSize: 14)),
          const Text('  Kullanım amacı: Bulantı, kusma ve araç tutması semptomları.', style: TextStyle(fontSize: 14, height: 1.4)),
          const Text('  SKT: 24 ay', style: TextStyle(fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }
}