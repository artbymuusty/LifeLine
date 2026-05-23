// lib/screens/home_screen.dart

import 'dart:convert';
import 'package:acil_yardim_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../services/database_service.dart';
import '../screens/notifications_screen.dart';


// Özel çanta modelini tanımlayalım
class CustomKit {
  final String id;
  final String name;

  CustomKit({required this.id, required this.name});

  factory CustomKit.fromMap(Map<String, dynamic> map) {
    return CustomKit(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}

// Ana ekran widget'ı
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


// State sınıfı
class _HomeScreenState extends State<HomeScreen> {
  String? _selectedKit;
  bool _sending = false;
  String? _error;

  final List<CustomKit> _customKits = [];

  @override
  void initState() {
    super.initState();
    _loadCustomKits();
  }

  // Özel çantaları veritabanından yükleyen metot
  Future<void> _loadCustomKits() async {
    try {
      final rows = await DatabaseService.getAllKits();
      final kits = rows.map<CustomKit>((row) => CustomKit.fromMap(row)).toList();
      setState(() {
        _customKits..clear()..addAll(kits);
      });
    } catch (e) {
      debugPrint('Özel çantalar yüklenirken hata: $e');
    }
  }

  // Çanta silme işlemi
  Future<void> _deleteKit(String id) async {
    await DatabaseService.deleteKit(id);
    setState(() {
      _customKits.removeWhere((kit) => kit.id == id);
      if (_selectedKit == id) _selectedKit = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Seçilen çanta silindi')),
    );
  }

  // Çanta seçimini temizleyen metot
  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser!;

    return Scaffold(
      // Uygulama çubuğu (AppBar) ayarları
      appBar: AppBar(
          title: const Text(
            'Umut Yanınızda',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications), // 🔔 Bildirim ikonu (sol üst)
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person), // 👤 Profil ikonu (sağ üst)
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),

      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: 2 + _customKits.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        if (index == 0) {
                          // Deprem çantası için özel bilgi veriyoruz
                          return _buildKitCard(
                            icon: Icons.home_repair_service,
                            title: 'Deprem Çantası',
                            info: ' ',
                            value: 'deprem',
                            onInfoTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Deprem Çantası'),
                                      content: SingleChildScrollView(
                                        child: Text(
                                          '''

  Teknik Eşya Paketi
_______________________________________
  • Reflektörlü Özel İkaz Yeleği
  • PN5 İş Eldiveni
  • 5 m Çok Amaçlı İp
  • El Feneri
  • Çok Amaçlı İsviçre Çakı 
  • 2 Kutu Kibrit
  • 6 Adet Pil
  • Metal Düdük
  • Tamir Bandı
  • Ventilli Maske
  
  İlk Yardım Seti
_______________________________________
  • 5 Adet Steril Gaz Kompres (7,5×7,5 cm)
  • 2 Paket Hidrofil Sargı Bezi
  • 20 ml Batikon Antiseptik Solüsyon
  • 10 Adet Yara Bandı
  • 3 Yara Örtüsü
  • 5 Adet Cilt Temizleme Mendili
  • 10 Adet Çengelli İğne
  • Medikal Yapıştırma Bandı (Flaster)
  • 4 Adet Cilt Temizleme Mendili 
  • Elastik Sargı Bandaj (Lastik)
  • Boyun Ateli (Boyunluk)
  • Anında Soğuk Kompres
  • 2 Adet Plastik Eldiven
  • Termal (Uzay) Battaniye
  • Mini El Feneri
  • Makas
  
  Gıda Paketi
_______________________________________
  • 140 g Ton Balığı
  • 400 g Fasulye Pilaki
  • 2 × 500 ml Su
  
  Hijyen Paketi
_______________________________________
  • 10’lu Islak Mendil
  • 10’lu Peçete
  • 15 g Sabun
  • 1 Adet Diş Fırçası
  • 10 g Diş Macunu
  
  • Polar Battaniye (140 × 185 cm)
  • 1 Adet Tükenmez Kalem
  • 1 Adet Not Defteri

            ''',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Kapat'),
                                        ),
                                      ],
                                    ),
                                  );
                                },

                          );
                        } else if (index == 1) {
                          // Sel çantası için özel bilgi veriyoruz
                          return _buildKitCard(
                            icon: Icons.home_repair_service,
                            title: 'Sel Çantası',
                            info: ' ',
                            value: 'sel',
                            onInfoTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Sel Çantası'),
                                      content: SingleChildScrollView(
                                        child: Text(
                                          '''

  Eşya Paketi
_______________________________________
  • Su geçirmez el feneri 
  • İlk yardım kiti 
  • Hijyen kiti 
  • Çizmeler
            ''',
                                  
                                   style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Kapat'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                          );
                        } else {
                          final kit = _customKits[index - 2];
                          // Özel çantalar için kart oluşturuyoruz (Silmek için buton ekliyoruz)
                          return Row(
                            children: [
                              Expanded(child: _buildCustomKitCard(kit)),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Emin misin?'),
                                      content: const Text('Seçilen çanta siliniyor'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Hayır'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _deleteKit(kit.id);
                                          },
                                          child: const Text('Evet'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),

                  // Çanta seçimi için butonlar
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton.extended(
                      heroTag: 'ozel_kit',
                      onPressed: () async {
                        final result = await Navigator.pushNamed(context, '/custom-kit');
                        if (result is CustomKit) {
                          await DatabaseService.insertKit(
                            result.id,
                            result.name,
                            <String>[]
                          );
                        }
                        await _loadCustomKits();
                        if (result is CustomKit) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Çantanız başarıyla oluşturuldu')),
                          );
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Özel Çanta Ekle'),
                    ),
                  ),

                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Çanta gönderme butonu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 217, 66, 66),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                ),
                onPressed: _sending ? null : _sendHelp,
                child: _sending
                    ? const SizedBox(
                        height: 23,
                        width: 23,
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 0, 0, 0),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Çanta Gönder', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Çanta kartlarını oluşturan yardımcı metot
  Widget _buildKitCard({
    required IconData icon,
    required String title,
    String? info,
    required String value,
    List<PopupMenuEntry>? menuItems,
    VoidCallback? onInfoTap,
  }) {
    final selected = value == _selectedKit;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedKit = value;
        _error = null;
      }),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.redAccent.shade100 : Colors.white,
          border: Border.all(color: selected ? kAccentColor : Colors.grey),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: kAccentColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(info ?? '', style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            if (onInfoTap != null)
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: onInfoTap,
              ),
          ],
        ),
      ),
    );
  }

  // Özel çanta kartı oluşturan metot
  Widget _buildCustomKitCard(CustomKit kit) {
    return _buildKitCard(
      icon: Icons.backpack,
      title: kit.name,
      info: ' ',
      value: kit.id,
      onInfoTap: () async {
        final rows = await DatabaseService.getAllKits();
        final match = rows.firstWhere((e) => e['id'] == kit.id, orElse: () => {});
        final items = (match['items'] ?? '').toString().split(',').where((e) => e.isNotEmpty).join(', ');

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                kit.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'İçerik Listesi:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Divider(),
                  Text(items), // 'items' String ise 
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
        },
      menuItems: [
        PopupMenuItem(
          child: const Text('Sil'),
          onTap: () {
            Future.delayed(Duration.zero, () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Emin misin?'),
                  content: const Text('Seçilen çanta siliniyor'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hayır'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteKit(kit.id);
                      },
                      child: const Text('Evet'),
                    ),
                  ],
                ),
              );
            });
          },
        ),
      ],
    );
  }

  // Çanta gönderme işlemini gerçekleştiren metot
  Future<void> _sendHelp() async {
    if (_selectedKit == null) {
      setState(() => _error = 'Lütfen önce bir çanta seçin.');
      return;
    }

    setState(() {
      _sending = true;
      _error = null;
    });

    try {
      final auth = context.read<AuthProvider>();
      final user = auth.currentUser!;
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final ts = DateTime.now().toUtc().toIso8601String();

      // Eğer özel bir çanta seçildiyse, içindeki öğeleri alıyoruz
      List<String> selectedItems = [];
      if (_selectedKit!.startsWith('ozel')) {
        final rows = await DatabaseService.getAllKits();
        final match = rows.firstWhere((e) => e['id'] == _selectedKit, orElse: () => {});
        if (match.isNotEmpty && match['items'] != null) {
          selectedItems = (match['items'] as String).split(',');
        }
      }

      // Eğer deprem ya da sel çantası seçildiyse, öğeleri sabit olarak ekliyoruz
      final body = {
        'kitType': _selectedKit,
        'userId': user.id,
        'lat': pos.latitude,
        'lng': pos.longitude,
        'timestamp': ts,
        if (selectedItems.isNotEmpty) 'selectedItems': selectedItems,
      };

      final uri = Uri.parse('$kBaseUrl$kHelpRequestEndpoint');
      final resp = await http.post(uri,
       headers: {'Content-Type': 'application/json'},
       body: jsonEncode(body),
      );

      // önce status code’a bakıyoruz
      if (resp.statusCode == 200 || resp.statusCode == 201) {
      } else {
        // hata; content-type’a göre JSON decode ya da raw body göster
        final ct = resp.headers['content-type'] ?? '';
        String errMsg;
        if (ct.contains('application/json')) {
          final data = jsonDecode(resp.body);
          errMsg = data['error'] ?? resp.body;
        } else {
          errMsg = resp.body;                      // HTML’i direkt burada kullanıyoruz
        }
        throw Exception('Sunucu hatası ${resp.statusCode}: $errMsg');
      }
    } catch (e) {
      setState(() => _error = 'Hata: ${e.toString()}');
    } finally {
      setState(() => _sending = false);
    }
  }
}
