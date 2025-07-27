import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:flutter/material.dart';
import 'package:islamibilgiler/abdest.dart';
import 'package:islamibilgiler/ad_helper.dart';
import 'package:islamibilgiler/dualar.dart';
import 'package:islamibilgiler/namazNasilKilinir.dart';
import 'package:islamibilgiler/sureler.dart';

import 'widget/ModernCard.dart';
import 'infoApp.dart';




/*
Appbar'ın arka plan rengi mavi olacak, yazı rengi siyah kalacak.
Appbar action alanında uygulama hakkında bilgilerin olduğu ekrana gidilecek.
 */



void main() {
  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namaz Rehberi',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Namaz Rehberi'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});





  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
  BannerAd? _bannerAd;

  @override
  void initState() {

    // TODO: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        leading: Icon(Icons.mosque),

        backgroundColor: Colors.blueAccent,

        title: Text(widget.title, style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),),
        actions: [
          IconButton(
            icon: Icon(Icons.info, color: Colors.black,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => infoApp(),
                )
              );
            }
          )
        ],

      ),
      body: Column(
        children: [

          // TODO: Display a banner when ready
          if (_bannerAd != null)
            Container(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),


          Container(
            height: (MediaQuery.of(context).size.height)*0.8,
            width: MediaQuery.of(context).size.width,

            child: GridView.count(

              crossAxisCount: 2,
              childAspectRatio: 1.0,
              children: [




                ModernCard(
                  title: 'Namaz Sureleri',
                  icon: Icons.menu_book_rounded,
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  pageToNavigate: namazSureleri(),
                  cardBackgroundImage: "assets/images/namazSureleri.jpg",
                  opacityOfCards: 0.04,
                ),
                ModernCard(
                  title: 'Namaz Duaları',
                  icon: Icons.mosque,
                  pageToNavigate: namazDualari(),
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  cardBackgroundImage: "assets/images/dua.jpg",
                  opacityOfCards: 0.05,
                ),

                ModernCard(
                  title: 'Namaz Nasıl Kılınır?',
                  iconColor: Colors.white,
                  icon: Icons.info,
                  pageToNavigate: nasilNamazKilinir(),
                  cardBackgroundImage: "assets/images/istanbul-cami.jpg",
                  opacityOfCards: 0.12,
                  textColor: Colors.white,
                ),
                ModernCard(
                  title: 'Abdest Nasıl Alınır?',
                  icon: Icons.info,
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  pageToNavigate: abdestNasilAlinir(),
                  cardBackgroundImage: "assets/images/cami-icAlan.jpg",
                  opacityOfCards: 0.4,
                ),


              ],
            ),
          ),
        ],
      )
    );
  }
}
