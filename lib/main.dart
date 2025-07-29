import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:islamibilgiler/providers/favorites_provider.dart';
import 'package:islamibilgiler/providers/settings_provider.dart';
import 'package:islamibilgiler/providers/theme_provider.dart';
import 'package:islamibilgiler/screens/home_screen.dart';
import 'package:islamibilgiler/services/notification_service.dart';
import 'package:islamibilgiler/utils/app_theme.dart'; // Yeni tema dosyamızı import ediyoruz
import 'package:provider/provider.dart';

final NotificationService notificationService = NotificationService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  await notificationService.init();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()), // YENİ PROVIDER'I EKLE
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            locale: Locale('tr', 'TR'),
            supportedLocales: [Locale('tr', 'TR')],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            title: 'İslami Bilgiler',
            debugShowCheckedModeBanner: false,


            // Eski ThemeData kodlarını yeni temalarımızla değiştiriyoruz
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme, // Yeni açık temamız
            darkTheme: AppTheme.darkTheme, // Yeni koyu temamız
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}