// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/help_request_provider.dart';
import '../utils/constants.dart';
import '../services/database_service.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';

// Brand constants for UX consistency
const String kAppName = 'LifeLine';
const String kAppSlogan = 'Umut Yanınızda';

// Local kit representation for custom SQLite kits
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedKit;
  final List<CustomKit> _customKits = [];

  @override
  void initState() {
    super.initState();
    _loadCustomKits();
  }

  // Load custom kits from SQLite database
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

  // Delete custom kit
  Future<void> _deleteKit(String id) async {
    await DatabaseService.deleteKit(id);
    setState(() {
      _customKits.removeWhere((kit) => kit.id == id);
      if (_selectedKit == id) _selectedKit = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Seçilen çanta başarıyla silindi.'),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final helpProvider = context.watch<HelpRequestProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          kAppSlogan, // Consistent brand slogan
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
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
                          return _buildKitCard(
                            icon: Icons.home_repair_service,
                            title: 'Deprem Çantası',
                            info: 'Teknik, İlk Yardım ve Gıda Paketleri',
                            value: 'deprem',
                            onInfoTap: () {
                              _showKitDialog(
                                'Deprem Çantası',
                                '''Teknik Eşya Paketi\n• Reflektörlü Özel İkaz Yeleği\n• İş Eldiveni\n• El Feneri ve Düdük\n• Çok Amaçlı Çakı\n\nİlk Yardım Seti\n• Steril Gaz Kompres\n• Sargı Bezi ve Yara Bandı\n• Antiseptik Solüsyon\n• Termal Battaniye\n\nGıda & Hijyen\n• Konserve Balık ve Pilaki\n• İçme Suyu\n• Islak Mendil ve Peçete''',
                              );
                            },
                          );
                        } else if (index == 1) {
                          return _buildKitCard(
                            icon: Icons.home_repair_service,
                            title: 'Sel Çantası',
                            info: 'Su Geçirmez Malzemeler ve Koruyucu Ekipmanlar',
                            value: 'sel',
                            onInfoTap: () {
                              _showKitDialog(
                                'Sel Çantası',
                                '''Eşya Paketi\n• Su geçirmez el feneri\n• İlk yardım kiti\n• Hijyen kiti\n• Çizmeler ve Yağmurluk''',
                              );
                            },
                          );
                        } else {
                          final kit = _customKits[index - 2];
                          return Row(
                            children: [
                              Expanded(child: _buildCustomKitCard(kit)),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => _confirmDelete(kit),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
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
                            const SnackBar(content: Text('Özel çantanız başarıyla oluşturuldu.')),
                          );
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Özel Çanta Ekle'),
                    ),
                  ),
                  if (helpProvider.lastError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      helpProvider.lastError!,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
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
                onPressed: helpProvider.isLoading ? null : _sendHelp,
                child: helpProvider.isLoading
                    ? const SizedBox(
                        height: 23,
                        width: 23,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Çanta Gönder', 
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Display details of standard kits
  void _showKitDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  // Confirmation dialog before deleting a custom kit
  void _confirmDelete(CustomKit kit) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Emin misin?'),
        content: Text('"${kit.name}" çantası silinecektir. Onaylıyor musunuz?'),
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
  }

  // Standard kit card widget builder
  Widget _buildKitCard({
    required IconData icon,
    required String title,
    String? info,
    required String value,
    VoidCallback? onInfoTap,
  }) {
    final selected = value == _selectedKit;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedKit = value;
      }),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.redAccent.shade100.withOpacity(0.3) : Colors.white,
          border: Border.all(color: selected ? kAccentColor : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              blurRadius: 4, 
              color: selected ? kAccentColor.withOpacity(0.1) : Colors.black12,
              offset: const Offset(0, 2),
            )
          ],
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
                  if (info != null && info.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(info, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
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

  // Custom kit card builder
  Widget _buildCustomKitCard(CustomKit kit) {
    return _buildKitCard(
      icon: Icons.backpack,
      title: kit.name,
      info: 'Özel Oluşturulmuş Çanta',
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
                Text(items.isEmpty ? 'Herhangi bir malzeme eklenmedi.' : items),
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
    );
  }

  // Encapsulated dispatching method delegating requests to HelpRequestProvider
  Future<void> _sendHelp() async {
    if (_selectedKit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen önce bir çanta seçin.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Retrieve selected custom kit items if custom kit is chosen
    List<String> selectedItems = [];
    if (_selectedKit!.startsWith('ozel')) {
      try {
        final rows = await DatabaseService.getAllKits();
        final match = rows.firstWhere((e) => e['id'] == _selectedKit, orElse: () => {});
        if (match.isNotEmpty && match['items'] != null) {
          selectedItems = (match['items'] as String).split(',').where((e) => e.isNotEmpty).toList();
        }
      } catch (e) {
        debugPrint('Custom items parse error: $e');
      }
    }

    final provider = context.read<HelpRequestProvider>();
    provider.selectedKit = _selectedKit;
    
    // Dispatch call through state provider pipeline
    final success = await provider.sendRequest(context, selectedItems: selectedItems);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🚨 Yardım çağrınız ve konumunuz başarıyla gönderildi.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.lastError ?? 'Çağrı gönderilemedi. Lütfen tekrar deneyin.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
