// lib/screens/qibla_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamibilgiler/widgets/qibla_compass.dart';
import 'dart:async';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();
  final _locationStream = Geolocator.getServiceStatusStream();
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _checkLocationStatus();
  }

  void _checkLocationStatus() {
    _positionStream = Geolocator.getPositionStream().listen((Position position) {
      setState(() {}); // Konum değiştikçe arayüzü yenile
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _deviceSupport,
      builder: (_, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !(snapshot.data ?? false)) {
          return const Center(child: Text("Hata: Cihazınızda sensör desteği bulunmuyor."));
        } else {
          return StreamBuilder(
            stream: FlutterQiblah.qiblahStream,
            builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Hata: ${snapshot.error.toString()}"));
              }

              final qiblahDirection = snapshot.data;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Kıble Yönü",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${qiblahDirection?.direction.toStringAsFixed(2)}°",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 300,
                    child: QiblaCompass(
                      qiblaDirection: qiblahDirection?.qiblah ?? 0.0,
                      compassDirection: qiblahDirection?.direction ?? 0.0,
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}