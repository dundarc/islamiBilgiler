import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:islamibilgiler/ad_helper.dart';
import 'package:islamibilgiler/widget/htmlViewer.dart';

class hizliListTile extends StatelessWidget{
  final String? title;
  final String? imagePath;
  final String? duaData;

  const hizliListTile({Key? key, this.title, this.imagePath, this.duaData}) : super(key: key);




  @override
  Widget build(BuildContext context){
    return  ListTile(
      title: Text(this.title??"Dua Adı Null dualar.dart"),
      onTap: () {

        Navigator.push(context, MaterialPageRoute(builder: (context) => hizliEkranDualar(duaAdi: this.title??"Dua Adı Null dualar.dart",duaDetay: this.duaData??"/textDosyalari/text.txt", duaJPGPath: this.imagePath??"/images/mosque.jpg",)));
      },
    );
  }
}




class namazDualari extends StatefulWidget {
  const namazDualari({Key? key}) : super(key: key);

  @override
  State<namazDualari> createState() => _namazDualariState();
}

class _namazDualariState extends State<namazDualari> {






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Namaz Duaları"),
        backgroundColor: Colors.cyanAccent,
      ),
      body: Column(

          children: [



            hizliListTile(title: "Sübhaneke", duaData: "assets/textDosyalari/dualar/subhaneke.txt", imagePath: "assets/images/DualarNamaz/subhaneke.png",),
            hizliListTile(title: "Rabbena", duaData: "assets/textDosyalari/dualar/rabbena.txt", imagePath: "assets/images/DualarNamaz/Rabbena.png",),
            hizliListTile(title: "Ettehiyyatü", duaData: "assets/textDosyalari/dualar/tahiyyat.txt", imagePath: "assets/images/DualarNamaz/tahiyyat.png",),
            hizliListTile(title: "Salli Barik", duaData: "assets/textDosyalari/dualar/salliBarik.txt", imagePath: "assets/images/DualarNamaz/salliBarik.png",),
            hizliListTile(title: "Kunut Duaları", duaData: "assets/textDosyalari/dualar/kunutDualari.txt", imagePath: "assets/images/DualarNamaz/kunutDualari.png",),




          ]
      ),
    );
  }
}



//Hızlı Ekran Dualar

// Sureler ekranından buranın ilgili Scaffold ekranı getirilecek

class hizliEkranDualar extends StatefulWidget {
  final String? duaAdi;
  final String? duaJPGPath;
  final String? duaDetay;
  const hizliEkranDualar({Key? key, this.duaAdi, this.duaJPGPath, this.duaDetay}) : super(key: key);

  @override
  State<hizliEkranDualar> createState() => _hizliEkranDualarState();
}

class _hizliEkranDualarState extends State<hizliEkranDualar> {

  String fileContent = ''; // Dosya içeriğini tutmak için değişken


  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
  BannerAd? _bannerAd;


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
// TODO: Load an Interstitial Ad

  @override
  void initState() {
    super.initState();
    _loadFileContent(); // Dosya içeriğini yükle

    if (_interstitialAd != null) {
      _interstitialAd?.show();
    }else{
      print("içerik boş");
    }

    // TODO: Load a banner ad
    BannerAd(
      adUnitId: "ca-app-pub-5204870751552541/1063844898",
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
        title: Text(widget.duaAdi??"Dua Adı null (dualar.dart)"),
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
