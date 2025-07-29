import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:islamibilgiler/providers/settings_provider.dart';
import 'package:islamibilgiler/services/notification_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart'; // Provider'ı import ediyoruz

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final NotificationService _notificationService = NotificationService();
  PrayerTimes? _prayerTimes;
  String? _address;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getPrayerTimes();
  }

  Future<void> _getPrayerTimes() async {
    setState(() { _isLoading = true; _errorMessage = null; });

    // Hatanın çözümü için SettingsProvider'a buradan erişiyoruz
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      try {
        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        String city = "Bilinmeyen Konum";
        if (placemarks.isNotEmpty) {
          city = placemarks.first.administrativeArea ?? placemarks.first.locality ?? "Bilinmeyen";
        }

        final myCoordinates = Coordinates(position.latitude, position.longitude);
        // Hesaplama yöntemini Provider'dan alıyoruz
        final params = settingsProvider.calculationMethod.getParameters();
        params.madhab = Madhab.shafi;
        final prayerTimes = PrayerTimes.today(myCoordinates, params);

        if (mounted) {
          setState(() {
            _prayerTimes = prayerTimes;
            _address = city;
            _isLoading = false;
          });
        }

        // --- HATA BURADAYDI, ŞİMDİ DÜZELTİLDİ ---
        // Eksik olan settingsProvider parametresini ekliyoruz
        await _notificationService.scheduleDailyPrayerNotifications(prayerTimes, settingsProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bugünün namaz vakitleri için bildirimler planlandı.')),
          );
        }

      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Konum alınamadı veya vakitler hesaplanamadı.';
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _errorMessage = 'Namaz vakitlerini görmek için konum izni vermelisiniz.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getPrayerTimes,
                child: const Text('İzin Ver ve Tekrar Dene'),
              )
            ],
          ),
        ),
      )
          : _buildPrayerTimesList(),
    );
  }

  Widget _buildPrayerTimesList() {
    if (_prayerTimes == null) {
      return const Center(child: Text('Namaz vakitleri bulunamadı.'));
    }

    final now = DateTime.now();
    final nextPrayer = _prayerTimes!.nextPrayer();
    final timeFormat = DateFormat('HH:mm');

    final prayerData = {
      'İmsak': _prayerTimes!.fajr,
      'Güneş': _prayerTimes!.sunrise,
      'Öğle': _prayerTimes!.dhuhr,
      'İkindi': _prayerTimes!.asr,
      'Akşam': _prayerTimes!.maghrib,
      'Yatsı': _prayerTimes!.isha,
    };

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_address != null)
                Text(_address!, style: Theme.of(context).textTheme.headlineSmall),
              Text(DateFormat.yMMMMd('tr_TR').format(now), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Text("Sonraki Vakit: ${prayerName(nextPrayer)}", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: prayerData.length,
            itemBuilder: (context, index) {
              final prayerNameKey = prayerData.keys.elementAt(index);
              final prayerTime = prayerData.values.elementAt(index);
              final isNextPrayer = _prayerTimes!.nextPrayer() == Prayer.values[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: isNextPrayer ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                child: ListTile(
                  leading: Icon(_getPrayerIcon(prayerNameKey), color: Theme.of(context).primaryColor),
                  title: Text(prayerNameKey, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text(timeFormat.format(prayerTime), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName) {
      case 'İmsak': return Icons.nightlight_round;
      case 'Güneş': return Icons.wb_sunny_outlined;
      case 'Öğle': return Icons.wb_sunny;
      case 'İkindi': return Icons.cloud_outlined;
      case 'Akşam': return Icons.nightlight;
      case 'Yatsı': return Icons.dark_mode;
      default: return Icons.timer;
    }
  }

  String prayerName(Prayer prayer) {
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
}