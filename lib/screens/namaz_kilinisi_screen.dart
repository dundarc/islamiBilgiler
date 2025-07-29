import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamibilgiler/models/icerik_model.dart';
import 'package:islamibilgiler/services/data_service.dart';

class NamazKilinisiScreen extends StatefulWidget {
  const NamazKilinisiScreen({super.key});

  @override
  State<NamazKilinisiScreen> createState() => _NamazKilinisiScreenState();
}

class _NamazKilinisiScreenState extends State<NamazKilinisiScreen> {
  final DataService _dataService = DataService();
  late Future<List<Icerik>> _namazKilinisiFuture;

  @override
  void initState() {
    super.initState();
    _namazKilinisiFuture = _dataService.loadNamazKilinisi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Namaz Nasıl Kılınır?'),
      ),
      body: FutureBuilder<List<Icerik>>(
        future: _namazKilinisiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Veri yüklenemedi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('İçerik bulunamadı.'));
          } else {
            final namazBilgileri = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: namazBilgileri.length,
              itemBuilder: (context, index) {
                final item = namazBilgileri[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.baslik,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // JSON içindeki <b> gibi etiketleri yorumlamak için HtmlWidget kullanıyoruz
                        HtmlWidget(
                          item.icerik,
                          textStyle: GoogleFonts.openSans(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}