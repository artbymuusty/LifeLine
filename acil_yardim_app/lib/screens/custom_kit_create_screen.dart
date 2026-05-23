// lib/screens/custom_kit_create_screen.dart

import 'package:flutter/material.dart';
import '../models/custom_kit.dart';
import '../services/database_service.dart';
import 'info_screen.dart';  // Bilgilendirme ekranı

class CustomKitCreateScreen extends StatefulWidget {
  const CustomKitCreateScreen({Key? key}) : super(key: key);

  @override
  State<CustomKitCreateScreen> createState() => _CustomKitCreateScreenState();
}

// Özel yardım çantası oluşturma ekranı
class _CustomKitCreateScreenState extends State<CustomKitCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kitNameController = TextEditingController();
  final List<String> _selectedItems = [];

  // Malzeme ve açıklamaları
  final Map<String, String> _itemDescriptions = {
    'Yara Bandı': 'Yara iyileşmesini destekler, küçük kesiklerde kullanılır.',
    'Steril Gaz Bezi': 'Yaraları temizler ve korur.',
    'Parasetamol': 'Ağrı kesici ve ateş düşürücü ilaç.',
    'Powerbank': 'Telefon ve aparatları şarj etmek için taşınabilir batarya.',
    'Fener': 'Karanlıkta ışık kaynağı sağlar.',
    'ORS': 'Sıvı ve elektrolit dengesini korumak için solüsyon.',
    'Antihistaminik': 'Alerjik tepkileri hafifletir.',
    'Antiseptik Solüsyon': 'Yara ve ekipmanları dezenfekte eder.',
    'Silverdin': 'Yanık tedavisinde kullanılır, enfeksiyon riskini azaltır.',
    'Betadine': 'Yara temizliği ve dezenfeksiyonu için kullanılır.',
    'Ateş Ölçer': 'Vücut sıcaklığını ölçmek için kullanılır.',
    'İbuprofen': 'Ağrı kesici ve iltihap önleyici ilaç.',
    'El Dezenfektanı': 'Ellerin temizlenmesi için kullanılır.',
    'Loperamid': 'İshal tedavisinde kullanılır.',
    'Asetaminofen': 'Ağrı kesici ve ateş düşürücü ilaç.',
    'Dramamin': 'Bulantı ve kusmayı önler.',
    'Buscopan': 'Karın ağrısı ve spazmları hafifletir.',
    'Alerji İlaçları': 'Alerjik reaksiyonları hafifletir.',
    'ORS (Oral Rehydration Salt)': 'Sıvı kaybını önlemek için kullanılır.',
   
  };

  bool _saving = false;

  @override
  void dispose() {
    _kitNameController.dispose();
    super.dispose();
  }

  // Çantayı kaydetme işlemi
  Future<void> _saveKit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir malzeme seçin.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final id = 'ozel_${DateTime.now().millisecondsSinceEpoch}';
      final name = _kitNameController.text.trim();
      await DatabaseService.insertKit(id, name, _selectedItems);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Çantanız başarıyla oluşturuldu!')),
      );
      final newKit = CustomKit(id: id, name: name, items: _selectedItems);
      Navigator.pop(context, newKit);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kaydetme sırasında hata: \$e')),
      );
    } finally {
      setState(() => _saving = false);
    }
  }


  // Özel yardım çantası oluşturma ekranı
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Özel Yardım Çantası'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bilgilendirme kartı
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      '💡 Öneriler ve Bilgilendirme',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const InfoScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Çanta adı
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _kitNameController,
                decoration: const InputDecoration(
                  labelText: 'Çantana bir isim ver',
                  border: UnderlineInputBorder(),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Lütfen bir isim girin.' : null,
              ),
            ),
            const SizedBox(height: 24),

            // Malzeme listesi
            const Text(
              'Malzemeleri seç:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Malzeme seçim listesi
            Expanded(
              child: ListView(
                children: _itemDescriptions.keys.map((item) {
                  final selected = _selectedItems.contains(item);
                  return Row(
                    children: [
                      Expanded(child: Text(item)),                     
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(item),
                              content: Text(
                                  _itemDescriptions[item] ?? 'Açıklama buraya yazılacak'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Kapat'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Checkbox(
                        value: selected,
                        onChanged: (on) {
                          setState(() {
                            if (on == true) {
                              _selectedItems.add(item);
                            } else {
                              _selectedItems.remove(item);
                            }
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Kaydet
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _saveKit,
                icon: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check),
                label:
                    Text(_saving ? 'Kaydediliyor...' : 'Çantayı Oluştur'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, minimumSize: const Size.fromHeight(48)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}