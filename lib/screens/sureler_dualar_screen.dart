import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamibilgiler/models/sure_dua_model.dart';
import 'package:islamibilgiler/providers/favorites_provider.dart';
import 'package:islamibilgiler/services/data_service.dart';
import 'package:provider/provider.dart';

class SurelerDualarScreen extends StatefulWidget {
  const SurelerDualarScreen({super.key});

  @override
  State<SurelerDualarScreen> createState() => _SurelerDualarScreenState();
}

class _SurelerDualarScreenState extends State<SurelerDualarScreen> {
  final DataService _dataService = DataService();
  final TextEditingController _searchController = TextEditingController();

  List<SureDua> _allItems = [];
  List<SureDua> _filteredItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterList);
  }

  Future<void> _loadData() async {
    final sureler = await _dataService.loadSureler();
    final dualar = await _dataService.loadDualar();

    if(mounted){
      setState(() {
        _allItems = [...sureler, ...dualar];
        _allItems.sort((a, b) => a.baslik.compareTo(b.baslik));
        _filteredItems = _allItems;
        _isLoading = false;
      });
    }
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems.where((item) {
        return item.baslik.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      // --- YENİ EKLENEN KISIM ---
      appBar: AppBar(
        title: const Text('Sureler ve Dualar'),
        // Bu AppBar, ana AppBar'dan bağımsız olduğu için geri tuşu otomatik gelmez.
        // Eğer istenirse manuel olarak eklenebilir.
        automaticallyImplyLeading: false,
      ),
      // ---
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Sure veya Dua Ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final isFav = favoritesProvider.isFavorite(item.baslik);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    title: Text(item.baslik, style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.star : Icons.star_border,
                        color: isFav ? Colors.amber : Colors.grey,
                      ),
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
            ),
          ),
        ],
      ),
    );
  }
}