import 'package:flutter/material.dart';
import 'package:islamibilgiler/providers/settings_provider.dart';
import 'package:islamibilgiler/providers/theme_provider.dart';
import 'package:islamibilgiler/screens/gizlilik_politikasi_screen.dart';
import 'package:provider/provider.dart';
import 'package:adhan/adhan.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider'lara erişim sağlıyoruz
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    // Hesaplama metotları için bir map oluşturalım
    final calculationMethods = {
      'Diyanet (Türkiye)': CalculationMethod.turkey,
      'Muslim World League': CalculationMethod.muslim_world_league,
      'Egyptian General Authority': CalculationMethod.egyptian,
      'University of Islamic Sciences, Karachi': CalculationMethod.karachi,
      'North America (ISNA)': CalculationMethod.north_america,
    };

    return ListView(
      padding: const EdgeInsets.all(12.0),
      children: [
        // Tema Ayarı
        _buildSettingsCard(
          context,
          icon: themeProvider.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
          title: 'Karanlık Mod',
          child: Switch.adaptive(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme(value);
            },
          ),
        ),
        const SizedBox(height: 12),

        // --- HATA BURADAYDI, ŞİMDİ DÜZELTİLDİ ---
        // Hesaplama Yöntemi Ayarı için özel bir Card oluşturuyoruz
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Namaz Vakti Hesaplama Yöntemi',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                DropdownButton<CalculationMethod>(
                  value: settingsProvider.calculationMethod,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: calculationMethods.entries.map((entry) {
                    return DropdownMenuItem<CalculationMethod>(
                      value: entry.value,
                      child: Text(entry.key, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      settingsProvider.setCalculationMethod(newValue);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        // --- DÜZELTME SONU ---

        const SizedBox(height: 12),
        // Bildirim Ayarları Başlığı
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            'Vakit Bildirimleri',
            style: (Theme.of(context).textTheme.titleLarge ?? const TextStyle()).copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Her Vakit için Bildirim Ayarı
        _buildNotificationSwitch(context, settingsProvider, 'İmsak', Prayer.fajr, settingsProvider.fajrNotify),
        _buildNotificationSwitch(context, settingsProvider, 'Öğle', Prayer.dhuhr, settingsProvider.dhuhrNotify),
        _buildNotificationSwitch(context, settingsProvider, 'İkindi', Prayer.asr, settingsProvider.asrNotify),
        _buildNotificationSwitch(context, settingsProvider, 'Akşam', Prayer.maghrib, settingsProvider.maghribNotify),
        _buildNotificationSwitch(context, settingsProvider, 'Yatsı', Prayer.isha, settingsProvider.ishaNotify),
        const SizedBox(height: 12),
        // Diğer Ayarlar
        _buildSettingsCard(
          context,
          icon: Icons.privacy_tip_outlined,
          title: 'Gizlilik Politikası',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GizlilikPolitikasiScreen()),
            );
          },
        ),
      ],
    );
  }

  // Tekrarlanan Card yapısı için yardımcı bir metot
  Widget _buildSettingsCard(BuildContext context, {required IconData icon, required String title, Widget? child, VoidCallback? onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: child,
        onTap: onTap,
      ),
    );
  }

  // Tekrarlanan SwitchListTile yapısı için yardımcı bir metot
  Widget _buildNotificationSwitch(BuildContext context, SettingsProvider provider, String title, Prayer prayer, bool value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile.adaptive(
        title: Text(title),
        value: value,
        onChanged: (newValue) {
          provider.setNotificationSetting(prayer, newValue);
        },
        secondary: Icon(Icons.notifications_outlined, color: Theme.of(context).primaryColor),
      ),
    );
  }
}