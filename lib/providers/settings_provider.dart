import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';

class SettingsProvider with ChangeNotifier {
  // Ayarları kaydetmek için anahtarlar
  static const String _methodKey = 'prayer_calculation_method';
  static const String _soundKey = 'notification_sound';
  static const String _fajrNotifyKey = 'fajr_notify';
  static const String _dhuhrNotifyKey = 'dhuhr_notify';
  static const String _asrNotifyKey = 'asr_notify';
  static const String _maghribNotifyKey = 'maghrib_notify';
  static const String _ishaNotifyKey = 'isha_notify';

  // Varsayılan değerler
  CalculationMethod _calculationMethod = CalculationMethod.turkey;
  String _notificationSound = 'varsayilan';
  bool _fajrNotify = true;
  bool _dhuhrNotify = true;
  bool _asrNotify = true;
  bool _maghribNotify = true;
  bool _ishaNotify = true;

  // Değerlere dışarıdan erişim için getter'lar
  CalculationMethod get calculationMethod => _calculationMethod;
  String get notificationSound => _notificationSound;
  bool get fajrNotify => _fajrNotify;
  bool get dhuhrNotify => _dhuhrNotify;
  bool get asrNotify => _asrNotify;
  bool get maghribNotify => _maghribNotify;
  bool get ishaNotify => _ishaNotify;

  // Ses seçenekleri
  final Map<String, String> soundOptions = {
    'varsayilan': 'Varsayılan Bildirim Sesi',
    'sessiz': 'Sessiz',
  };

  SettingsProvider() {
    _loadSettings();
  }

  // Ayarları cihaz hafızasından yükle
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final methodName = prefs.getString(_methodKey) ?? 'turkey';
    _calculationMethod = _getMethodByName(methodName);

    _notificationSound = prefs.getString(_soundKey) ?? 'varsayilan';

    _fajrNotify = prefs.getBool(_fajrNotifyKey) ?? true;
    _dhuhrNotify = prefs.getBool(_dhuhrNotifyKey) ?? true;
    _asrNotify = prefs.getBool(_asrNotifyKey) ?? true;
    _maghribNotify = prefs.getBool(_maghribNotifyKey) ?? true;
    _ishaNotify = prefs.getBool(_ishaNotifyKey) ?? true;

    notifyListeners();
  }

  // Ayarları cihaz hafızasına kaydet
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_methodKey, _calculationMethod.name);
    await prefs.setString(_soundKey, _notificationSound);
    await prefs.setBool(_fajrNotifyKey, _fajrNotify);
    await prefs.setBool(_dhuhrNotifyKey, _dhuhrNotify);
    await prefs.setBool(_asrNotifyKey, _asrNotify);
    await prefs.setBool(_maghribNotifyKey, _maghribNotify);
    await prefs.setBool(_ishaNotifyKey, _ishaNotify);
  }

  // Metot ismine göre objeyi döndür
  CalculationMethod _getMethodByName(String name) {
    switch (name) {
      case 'turkey':
        return CalculationMethod.turkey;
      case 'muslim_world_league':
        return CalculationMethod.muslim_world_league;
      case 'egyptian':
        return CalculationMethod.egyptian;
      case 'karachi':
        return CalculationMethod.karachi;
      case 'north_america':
        return CalculationMethod.north_america;
      default:
        return CalculationMethod.turkey;
    }
  }

  // Hesaplama yöntemini güncelle
  void setCalculationMethod(CalculationMethod method) {
    if (_calculationMethod != method) {
      _calculationMethod = method;
      _saveSettings();
      notifyListeners();
    }
  }

  // Bildirim sesini güncelle
  void setNotificationSound(String sound) {
    if (_notificationSound != sound) {
      _notificationSound = sound;
      _saveSettings();
      notifyListeners();
    }
  }

  // Bildirim ayarını güncelle
  void setNotificationSetting(Prayer prayer, bool value) {
    switch(prayer) {
      case Prayer.fajr: _fajrNotify = value; break;
      case Prayer.dhuhr: _dhuhrNotify = value; break;
      case Prayer.asr: _asrNotify = value; break;
      case Prayer.maghrib: _maghribNotify = value; break;
      case Prayer.isha: _ishaNotify = value; break;
      default: break;
    }
    _saveSettings();
    notifyListeners();
  }
}