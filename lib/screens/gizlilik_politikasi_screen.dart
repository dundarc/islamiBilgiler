import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:islamibilgiler/models/icerik_model.dart';
import 'package:islamibilgiler/services/data_service.dart';

class GizlilikPolitikasiScreen extends StatefulWidget {
  const GizlilikPolitikasiScreen({super.key});

  @override
  State<GizlilikPolitikasiScreen> createState() => _GizlilikPolitikasiScreenState();
}

class _GizlilikPolitikasiScreenState extends State<GizlilikPolitikasiScreen> {
  final DataService _dataService = DataService();
  late Future<Icerik> _gizlilikPolitikasiFuture;

  @override
  void initState() {
    super.initState();
    _gizlilikPolitikasiFuture = _dataService.loadGizlilikPolitikasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gizlilik Politikası"),
      ),
      body: FutureBuilder<Icerik>(
        future: _gizlilikPolitikasiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Veri yüklenemedi: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('İçerik bulunamadı.'));
          } else {
            final politika = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: HtmlWidget(
                politika.icerik,
                textStyle: const TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}