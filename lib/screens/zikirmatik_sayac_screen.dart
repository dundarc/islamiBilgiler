import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class Tesbihat {
  final String ad;
  final int hedef;
  Tesbihat(this.ad, this.hedef);
}

class ZikirmatikSayacScreen extends StatefulWidget {
  final bool isSerbestZikir;
  const ZikirmatikSayacScreen({super.key, required this.isSerbestZikir});

  @override
  State<ZikirmatikSayacScreen> createState() => _ZikirmatikSayacScreenState();
}

class _ZikirmatikSayacScreenState extends State<ZikirmatikSayacScreen> {
  late List<Tesbihat> _tesbihatListesi;
  int _mevcutIndex = 0;
  int _sayac = 0;
  bool _canVibrate = false;

  @override
  void initState() {
    super.initState();
    _checkVibration();
    // Ekrana hangi modda geldiğimize göre tesbihat listesini belirliyoruz
    if (widget.isSerbestZikir) {
      _tesbihatListesi = [Tesbihat("Serbest Zikir", 9999)]; // Yüksek bir hedef belirleyelim
    } else {
      _tesbihatListesi = [
        Tesbihat("Sübhanallah", 33),
        Tesbihat("Elhamdülillah", 33),
        Tesbihat("Allahu Ekber", 33),
      ];
    }
  }

  Future<void> _checkVibration() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (mounted) setState(() => _canVibrate = hasVibrator ?? false);
  }

  void _sayaciArtir() {
    if (_canVibrate) Vibration.vibrate(duration: 50);
    setState(() => _sayac++);
  }

  void _sayaciSifirla() {
    setState(() => _sayac = 0);
  }

  void _sonrakiTesbihat() {
    setState(() {
      _mevcutIndex = (_mevcutIndex + 1) % _tesbihatListesi.length;
      _sayaciSifirla();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mevcutTesbihat = _tesbihatListesi[_mevcutIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSerbestZikir ? 'Serbest Zikir' : 'Namaz Tesbihatı'),
      ),
      body: Column(
        children: [
          // DEVASA DOKUNMA ALANI
          Expanded(
            flex: 3, // Bu alan daha büyük olsun
            child: GestureDetector(
              onTap: _sayaciArtir,
              child: Container(
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mevcutTesbihat.ad,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      _sayac.toString(),
                      style: TextStyle(
                        fontSize: 120, // Çok büyük font boyutu
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (!widget.isSerbestZikir)
                      Text(
                        "/ ${mevcutTesbihat.hedef}",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // ALT KONTROL ALANI
          Expanded(
            flex: 1, // Bu alan daha küçük olsun
            child: Container(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildControlButton(
                    icon: Icons.refresh,
                    label: "SIFIRLA",
                    onPressed: _sayaciSifirla,
                  ),
                  // "Sonraki" butonu sadece Namaz Tesbihatı modunda görünsün
                  if (!widget.isSerbestZikir)
                    _buildControlButton(
                      icon: Icons.skip_next,
                      label: "SONRAKİ",
                      onPressed: _sonrakiTesbihat,
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Büyük ve okunaklı kontrol butonu için yardımcı metot
  Widget _buildControlButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          iconSize: 50, // Büyük ikon boyutu
          color: Theme.of(context).primaryColor,
        ),
        Text(label, style: TextStyle(color: Theme.of(context).primaryColor)),
      ],
    );
  }
}