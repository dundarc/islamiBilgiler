import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamibilgiler/models/icerik_model.dart';
import 'package:islamibilgiler/services/data_service.dart';

class AbdestScreen extends StatefulWidget {
  const AbdestScreen({super.key});

  @override
  State<AbdestScreen> createState() => _AbdestScreenState();
}

class _AbdestScreenState extends State<AbdestScreen> {
  final DataService _dataService = DataService();
  late Future<List<Icerik>> _abdestBilgileriFuture;

  @override
  void initState() {
    super.initState();
    _abdestBilgileriFuture = _dataService.loadAbdestBilgileri();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abdest Nasıl Alınır?'),
      ),
      body: FutureBuilder<List<Icerik>>(
        future: _abdestBilgileriFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Veri yüklenemedi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('İçerik bulunamadı.'));
          } else {
            final abdestBilgileri = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: abdestBilgileri.length,
              itemBuilder: (context, index) {
                final item = abdestBilgileri[index];
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
                        Text(
                          item.icerik,
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            height: 1.5, // Satır aralığı
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