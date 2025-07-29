import 'dart:convert'; // Bu satır, UTF-8 dönüşümü için gereklidir.
import 'package:flutter/services.dart';
import 'package:islamibilgiler/models/sure_dua_model.dart';
import 'package:islamibilgiler/models/icerik_model.dart';

class DataService {
  // Veriyi okumak için tek bir merkezi ve garantili fonksiyon oluşturalım
  Future<Map<String, dynamic>> _loadData() async {
    // Dosyayı standart bir string olarak değil, ham baytlar olarak yüklüyoruz.
    final byteData = await rootBundle.load('assets/data/app_data.json');
    // Bu baytları, UTF-8 formatını kullanarak bilinçli olarak metne (string) çeviriyoruz.
    final String response = utf8.decode(byteData.buffer.asUint8List());
    // Son olarak JSON'ı parse ediyoruz.
    final data = await json.decode(response);
    return data;
  }

  Future<List<SureDua>> loadDualar() async {
    final data = await _loadData();
    List<dynamic> dualarList = data['dualar'];
    return dualarList.map((json) => SureDua.fromJson(json)).toList();
  }

  Future<List<SureDua>> loadSureler() async {
    final data = await _loadData();
    List<dynamic> surelerList = data['sureler'];
    return surelerList.map((json) => SureDua.fromJson(json)).toList();
  }

  Future<List<Icerik>> loadAbdestBilgileri() async {
    final data = await _loadData();
    List<dynamic> list = data['abdest'];
    return list.map((json) => Icerik.fromJson(json)).toList();
  }

  Future<List<Icerik>> loadNamazKilinisi() async {
    final data = await _loadData();
    List<dynamic> list = data['namaz_kilinisi'];
    return list.map((json) => Icerik.fromJson(json)).toList();
  }

  Future<Icerik> loadGizlilikPolitikasi() async {
    final data = await _loadData();
    return Icerik.fromJson(data['gizlilik_politikasi']);
  }
}