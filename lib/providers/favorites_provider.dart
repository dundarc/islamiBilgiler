import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _favoritesKey = 'favorites';
  List<String> _favoriteTitles = [];

  List<String> get favoriteTitles => _favoriteTitles;

  FavoritesProvider() {
    _loadFavorites();
  }

  // Favorileri cihaz hafızasından yükle
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteTitles = prefs.getStringList(_favoritesKey) ?? [];
    notifyListeners();
  }

  // Bir öğenin favori olup olmadığını kontrol et
  bool isFavorite(String title) {
    return _favoriteTitles.contains(title);
  }

  // Favoriyi ekle/kaldır
  Future<void> toggleFavorite(String title) async {
    if (isFavorite(title)) {
      _favoriteTitles.remove(title);
    } else {
      _favoriteTitles.add(title);
    }

    // Değişikliği cihaz hafızasına kaydet
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteTitles);

    notifyListeners();
  }
}