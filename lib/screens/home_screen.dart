import 'package:flutter/material.dart';
import 'package:islamibilgiler/screens/favorites_screen.dart';
import 'package:islamibilgiler/screens/home_content.dart';
import 'package:islamibilgiler/screens/prayer_times_screen.dart';
import 'package:islamibilgiler/screens/qibla_screen.dart';
import 'package:islamibilgiler/screens/settings_screen.dart';
import 'package:islamibilgiler/screens/sureler_dualar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Widget listesini IndexedStack içinde yöneteceğiz
  final List<Widget> _screens = const [
    HomeContent(),
    SurelerDualarScreen(),
    QiblaScreen(),
    PrayerTimesScreen(),
    FavoritesScreen(),
    SettingsScreen(), // Ayarlar ekranını da buraya ekleyelim
  ];

  static const List<String> _appBarTitles = [
    'Namaz Rehberi',
    'Sureler ve Dualar',
    'Kıble Bulucu',
    'Namaz Vakitleri',
    'Favorilerim',
    'Ayarlar' // Ayarlar için başlık
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        actions: [
          // Ayarlar butonunu AppBar'a taşıdık ve _selectedIndex'i 5 yapacak şekilde ayarladık
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              setState(() {
                _selectedIndex = 5; // Ayarlar ekranının indeksi
              });
            },
          ),
        ],
      ),
      // IndexedStack, sadece aktif olan sekmeyi gösterir ama diğerlerinin durumunu (state) korur.
      // Bu, sekmeler arası geçişte sayfaların sıfırlanmasını önler.
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex > 4 ? 0 : _selectedIndex, // Ayarlar seçiliyken ana sayfayı aktif göster
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Sureler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Kıble',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_outlined),
            activeIcon: Icon(Icons.access_time_filled),
            label: 'Vakitler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star),
            label: 'Favoriler',
          ),
        ],
      ),
    );
  }
}