import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamibilgiler/models/sure_dua_model.dart';
import 'package:islamibilgiler/providers/favorites_provider.dart';
import 'package:islamibilgiler/services/data_service.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FavoritesProvider'a erişerek favori başlık listesini alıyoruz
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteTitles = favoritesProvider.favoriteTitles;

    // Favori öğelerin tam içeriğini almak için tüm veriyi yüklüyoruz
    return FutureBuilder<List<SureDua>>(
      future: Future.wait([
        DataService().loadSureler(),
        DataService().loadDualar(),
      ]).then((lists) => lists.expand((list) => list).toList()),
      builder: (context, snapshot) {
        // Veri yüklenirken
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Hata durumunda
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Favoriler yüklenemedi.'));
        }

        final allItems = snapshot.data!;
        // Tüm liste içinden, başlığı favorilerde olanları filtreliyoruz
        final favoriteItems = allItems.where((item) => favoriteTitles.contains(item.baslik)).toList();

        // Eğer favori listesi boşsa, kullanıcıya bir mesaj gösteriyoruz
        if (favoriteItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_border,
                  size: 80,
                  color: Colors.grey.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Henüz favori eklemediniz.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Favori listesi doluysa, listeyi gösteriyoruz
        return ListView.builder(
          itemCount: favoriteItems.length,
          itemBuilder: (context, index) {
            final item = favoriteItems[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                // Başlangıçta açık gelmesi için
                initiallyExpanded: true,
                title: Text(item.baslik, style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                // Favoriden çıkarma butonu
                trailing: IconButton(
                  icon: const Icon(Icons.star, color: Colors.amber),
                  tooltip: 'Favorilerden Kaldır',
                  onPressed: () {
                    favoritesProvider.toggleFavorite(item.baslik);
                  },
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (item.arapca.isNotEmpty) ...[
                          Text('Arapça Okunuşu', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(item.arapca, style: GoogleFonts.amiri(fontSize: 22), textAlign: TextAlign.right),
                          const SizedBox(height: 16),
                        ],
                        if (item.okunusu.isNotEmpty) ...[
                          Text('Türkçe Okunuşu', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(item.okunusu, style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 16),
                        ],
                        if (item.anlami.isNotEmpty) ...[
                          Text('Anlamı', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(item.anlami, style: const TextStyle(fontSize: 16)),
                        ],
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}