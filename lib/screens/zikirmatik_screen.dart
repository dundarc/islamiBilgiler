import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

// Tesbihat verilerini tutacak basit bir model
class Tesbihat {
  final String ad;
  final int hedef;
  Tesbihat(this.ad, this.hedef);
}

class ZikirmatikScreen extends StatefulWidget {
  const ZikirmatikScreen({super.key});

  @override
  State<ZikirmatikScreen> createState() => _ZikirmatikScreenState();
}

class _ZikirmatikScreenState extends State<ZikirmatikScreen> {
  final List<Tesbihat> _tesbihatListesi = [
    Tesbihat("Sübhanallah", 33),
    Tesbihat("Elhamdülillah", 33),
    Tesbihat("Allahu Ekber", 33),
    Tesbihat("La ilahe illallah...", 1),
  ];

  int _mevcutIndex = 0;
  int _sayac = 0;
  bool _canVibrate = false; // Cihazın titreşip titreşemeyeceğini tutacak değişken

  @override
  void initState() {
    super.initState();
    _checkVibration(); // Uygulama açılırken titreşim özelliğini bir kez kontrol et
  }

  // Titreşim kontrolünü başlangıçta bir kez yapıyoruz
  Future<void> _checkVibration() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (mounted) {
      setState(() {
        _canVibrate = hasVibrator ?? false;
      });
    }
  }

  // Tıklama fonksiyonunu daha basit ve senkron hale getirdik
  void _sayaciArtir() {
    // Her tıklamada titreşim varsa titre
    if (_canVibrate) {
      Vibration.vibrate(duration: 50);
    }

    setState(() {
      if (_sayac < _tesbihatListesi[_mevcutIndex].hedef -1) { // Hedefe gelmeden bir önceki sayıya kadar artır
        _sayac++;
      } else {
        _sayac++; // Hedefe ulaştığında sayacı son kez artır ve göster
        // İsteğe bağlı: Hedefe ulaşıldığında daha uzun bir titreşim verilebilir
        if (_canVibrate) {
          Vibration.vibrate(duration: 200);
        }
      }
    });
  }

  void _sayaciSifirla() {
    setState(() {
      _sayac = 0;
    });
  }

  void _sonrakiTesbihat() {
    setState(() {
      if (_mevcutIndex < _tesbihatListesi.length - 1) {
        _mevcutIndex++;
      } else {
        _mevcutIndex = 0; // Başa dön
      }
      _sayaciSifirla(); // Yeni tesbihata başlarken sayacı sıfırla
    });
  }

  @override
  Widget build(BuildContext context) {
    final mevcutTesbihat = _tesbihatListesi[_mevcutIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tesbihat / Zikirmatik'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  mevcutTesbihat.ad,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Hedef: ${mevcutTesbihat.hedef}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: _sayaciArtir,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _sayac.toString(),
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _sayaciSifirla,
                  tooltip: "Sıfırla",
                  iconSize: 40,
                  color: Colors.grey.shade600,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _sonrakiTesbihat,
                  tooltip: "Sonraki Tesbihat",
                  iconSize: 40,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}