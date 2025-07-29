import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamibilgiler/screens/abdest_screen.dart';
import 'package:islamibilgiler/screens/namaz_kilinisi_screen.dart';
import 'package:islamibilgiler/screens/sureler_dualar_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:islamibilgiler/screens/zikirmatik_screen.dart';
import 'package:islamibilgiler/screens/zikirmatik_secim_screen.dart'; // Eski _sayac_ yerine _secim_ ekranını import et
import 'dart:async';
import 'package:timer_builder/timer_builder.dart';

// Ana menü öğeleri için model
class MenuItem {
  final String title;
  final IconData iconData;
  final Widget? targetScreen;

  MenuItem({
    required this.title,
    required this.iconData,
    this.targetScreen,
  });
}

// Ana sayfanın stateful widget'a dönüştürülmesi
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  PrayerTimes? _prayerTimes;
  Prayer? _nextPrayer;
  String _gununAyet_Arapca = "اِنَّا لِلّٰهِ وَاِنَّٓا اِلَيْهِ رَاجِعُونَؕ";
  String _gununAyet_Anlami = "\"Biz şüphesiz Allah'a aidiz ve şüphesiz O'na döneceğiz.\" (Bakara Suresi, 156)";

  @override
  void initState() {
    super.initState();
    _getPrayerTimes();
  }

  Future<void> _getPrayerTimes() async {
    // Konum izni kontrolü ve isteme
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      try {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        final myCoordinates = Coordinates(position.latitude, position.longitude);
        final params = CalculationMethod.turkey.getParameters();
        params.madhab = Madhab.shafi;

        if(mounted){
          setState(() {
            _prayerTimes = PrayerTimes.today(myCoordinates, params);
            _nextPrayer = _prayerTimes?.nextPrayer();
          });
        }

      } catch (e) {
        // Hata durumunda bir şey yapma, kart boş görünecektir
      }
    }
  }

  String _prayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr: return 'İmsak';
      case Prayer.sunrise: return 'Güneş';
      case Prayer.dhuhr: return 'Öğle';
      case Prayer.asr: return 'İkindi';
      case Prayer.maghrib: return 'Akşam';
      case Prayer.isha: return 'Yatsı';
      case Prayer.none: return 'Vakit Yok';
    }
  }

  // --- YENİ EKLENEN YARDIMCI FONKSİYON ---
  // Bu fonksiyon, bir sonraki vaktin DateTime nesnesini döndürür.
  DateTime _getTimeForPrayer(Prayer prayer) {
    if (_prayerTimes == null) return DateTime.now();
    switch (prayer) {
      case Prayer.fajr: return _prayerTimes!.fajr;
      case Prayer.sunrise: return _prayerTimes!.sunrise;
      case Prayer.dhuhr: return _prayerTimes!.dhuhr;
      case Prayer.asr: return _prayerTimes!.asr;
      case Prayer.maghrib: return _prayerTimes!.maghrib;
      case Prayer.isha: return _prayerTimes!.isha;
      case Prayer.none: return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<MenuItem> menuItems = [
      MenuItem(title: 'Sureler ve Dualar', iconData: Icons.menu_book, targetScreen: const SurelerDualarScreen()),
      MenuItem(title: 'Zikirmatik', iconData: Icons.fingerprint, targetScreen: const ZikirmatikSecimScreen()), // YÖNLENDİRMEYİ GÜNCELLE
      MenuItem(title: 'Abdest Nasıl Alınır?', iconData: Icons.water_drop, targetScreen: const AbdestScreen()),
      MenuItem(title: 'Namaz Nasıl Kılınır?', iconData: Icons.person, targetScreen: const NamazKilinisiScreen()),
    ];

    return ListView(
      padding: const EdgeInsets.all(12.0),
      children: [
        Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor, Colors.teal.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: _nextPrayer == null
                ? const Center(child: Text("Konum izni bekleniyor...", style: TextStyle(color: Colors.white)))
                : Column(
              children: [
                Text(
                  'Bir Sonraki Vakit',
                  style: GoogleFonts.openSans(fontSize: 18, color: Colors.white.withOpacity(0.9)),
                ),
                const SizedBox(height: 8),
                Text(
                  _prayerName(_nextPrayer!),
                  style: GoogleFonts.openSans(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  // Hatalı kodu yeni fonksiyonla değiştiriyoruz
                  DateFormat('HH:mm').format(_getTimeForPrayer(_nextPrayer!)),
                  style: GoogleFonts.openSans(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 16),
                TimerBuilder.periodic(
                  const Duration(seconds: 1),
                  builder: (context) {
                    final now = DateTime.now();
                    // Hatalı kodu yeni fonksiyonla değiştiriyoruz
                    final difference = _getTimeForPrayer(_nextPrayer!).difference(now);
                    return Text(
                      "Kalan Süre: ${difference.inHours.toString().padLeft(2, '0')}:${(difference.inMinutes % 60).toString().padLeft(2, '0')}:${(difference.inSeconds % 60).toString().padLeft(2, '0')}",
                      style: GoogleFonts.openSans(fontSize: 16, color: Colors.white.withOpacity(0.9)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Günün Ayeti",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  _gununAyet_Arapca,
                  style: GoogleFonts.amiri(fontSize: 22), textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _gununAyet_Anlami,
                  style: GoogleFonts.openSans(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 1.1,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return GestureDetector(
              onTap: () {
                if (item.targetScreen != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => item.targetScreen!),
                  );
                }
              },
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.iconData,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}