
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:islamibilgiler/ad_helper.dart';
import 'package:islamibilgiler/widget/htmlViewer.dart';


//Hızlı ekran STFULL

class hizliEkranSureler extends StatefulWidget {

  final String? duaAdi;
  final String? duaJPGPath;
  final String? duaDetay;


  const hizliEkranSureler({Key? key, this.duaAdi, this.duaJPGPath, this.duaDetay}) : super(key: key);



  @override
  State<hizliEkranSureler> createState() => _hizliEkranSurelerState();


}

class _hizliEkranSurelerState extends State<hizliEkranSureler> {

  String fileContent = ''; // Dosya içeriğini tutmak için değişken

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _loadFileContent(); // Dosya içeriğini yükle

    // TODO: Load a banner ad
    BannerAd(
      adUnitId: "ca-app-pub-5204870751552541/2217144461",
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

  Future<void> _loadFileContent() async {
    try {
      String content = await rootBundle.loadString('${widget.duaDetay??"assets/textDosyalari/text.txt"}');
      setState(() {
        fileContent = content; // Dosya içeriğini güncelle
      });
    } catch (e) {
      print("Hata: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.duaAdi??"Dua Adı null"),
        backgroundColor: Colors.cyanAccent,
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO: Display a banner when ready
                if (_bannerAd != null)
                  Container(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                Container(
                    height: 500,
                    width: 500,
                    child: Image.asset(widget.duaJPGPath??"assets/images/mosque.jpg")),
                htmlViewer(html: fileContent)
              ]
          )
      ),
    );
  }
}



class hizliListTile extends StatelessWidget{
  final String? title;
  final String? imagePath;
  final String? duaData;
  final IconData? icon;

  const hizliListTile({Key? key, this.title, this.imagePath, this.duaData, this.icon}) : super(key: key);





  @override
  Widget build(BuildContext context){
    return  ListTile(
      title: Text(this.title??"Dua Adı Null"),
      leading: this.icon!=null ? Icon(this.icon):null,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => hizliEkranSureler(duaAdi: this.title??"Dua Adı Null",duaDetay: this.duaData??"/textDosyalari/text.txt", duaJPGPath: this.imagePath??"/images/mosque.jpg",)));
      },
    );
  }
}




class namazSureleri extends StatefulWidget {
  const namazSureleri({Key? key}) : super(key: key);

  @override
  State<namazSureleri> createState() => _namazSureleriState();
}

class _namazSureleriState extends State<namazSureleri> {

  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {

            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    if (_interstitialAd != null) {
      _interstitialAd?.show();
    }else{
      print("içerik boş");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Namaz Sureleri"),
        backgroundColor: Colors.cyanAccent,
      ),
      body: ListView(
        shrinkWrap: true,
        children: const [



              hizliListTile(imagePath: "assets/images/Sureler/fatiha.jpg", title: "Fatiha", duaData: "assets/textDosyalari/fatiha.txt",),
              hizliListTile(imagePath: "assets/images/Sureler/felakSuresi.png", title: "Felak Suresi", duaData: "assets/textDosyalari/felakSuresi.txt",),
              hizliListTile(imagePath: 'assets/images/Sureler/filSuresi.png', title: "Fil Suresi", duaData: "assets/textDosyalari/filSuresi.txt",),
              hizliListTile(imagePath: "assets/images/Sureler/ihlasSuresi.png", title: "İhlas Suresi", duaData: "assets/textDosyalari/ihlasSuresi.txt",),
              hizliListTile(imagePath: 'assets/images/Sureler/insirahSuresi.png', title: "İnşirah Suresi", duaData: "assets/textDosyalari/insirahSuresi.txt",),
              hizliListTile(imagePath: "assets/images/Sureler/kafirunSuresi.png", title: "Kafirun Suresi", duaData: "assets/textDosyalari/kafirunSuresi.txt",),
              hizliListTile(imagePath: 'assets/images/Sureler/kevserSuresi.png', title: "Kevser Suresi", duaData: "assets/textDosyalari/kevserSuresi.txt",),
              hizliListTile(imagePath: 'assets/images/Sureler/kureysSuresi.png', title: "Kureys Suresi", duaData: "assets/textDosyalari/kureysSuresi.txt",),
              hizliListTile(imagePath: 'assets/images/Sureler/maunSuresi.png', title: "Maun Suresi", duaData: "assets/textDosyalari/maunSuresi.txt",),
              hizliListTile(imagePath: 'assets/images/Sureler/nasrSuresi.png', title: "Nasr Suresi", duaData: "assets/textDosyalari/nasrSuresi.txt",),
              hizliListTile(imagePath: 'assets/images/Sureler/nasSuresi.png', title: "Nas Suresi", duaData: "assets/textDosyalari/nasSuresi.txt",),
              hizliListTile(imagePath: 'assets/images/Sureler/tebbetSuresi.png', title: "Tebbet Suresi", duaData: "assets/textDosyalari/tebbetSuresi.txt",),
              hizliListTile(imagePath: 'assets/images/Sureler/ayetElKursi.png', title: "Ayetül-Kürsî", duaData: "assets/textDosyalari/ayetElKursi.txt",),
              hizliListTile(imagePath: 'assets/images/mosque.jpg', title: "Yasin Suresi", duaData: "assets/textDosyalari/yasinSuresi.txt",)


        ]
      ),
    );
  }
}






