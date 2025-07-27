import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:islamibilgiler/ad_helper.dart';
import 'package:islamibilgiler/widget/htmlViewer.dart';



//Önemli Widgetlerin olduğu alan


class fullPageCreatorForPray extends StatelessWidget {
  final String title;
  final Color? backgroundColorForTitle;
  final String htmlContent;

  fullPageCreatorForPray({required this.title, this.backgroundColorForTitle, required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: backgroundColorForTitle ?? Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Image.asset("assets/images/namazTurleriGoruntu.jpg")),
              ),
              htmlViewer(html: htmlContent) 
            ])
    ));
  }
}


class listTileNamaz extends StatelessWidget {

  final Icon iconText;
  final String textForListTile;
  final bool? borderSet;
  final Color? textColor;
  final double? textSize;
  final Widget pageToNavigate;

  listTileNamaz({required this.iconText, required this.textForListTile, this.borderSet, this.textColor, this.textSize, required this.pageToNavigate});


//Nasıl Namaz Kılınır Listile ekranı

  @override
  Widget build(BuildContext context){
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => pageToNavigate));
      },
      leading: Icon(iconText.icon),
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0), // Üst ve alt boşluk
        decoration: BoxDecoration(
            border: ((){
              if(borderSet==true){
                return  Border(
              top: BorderSide(color: Colors.black), // Üst kenar siyah border
              bottom: BorderSide(color: Colors.black), // Alt kenar siyah border
              );
              }
              return null;
            }())
        ),
        child: Text(textForListTile, style: TextStyle(color: (textColor==null)? Colors.black: textColor, fontSize: textSize),),
      ),
    );
  }

}





//Nasıl Namaz Kılınır alanı

class nasilNamazKilinir extends StatefulWidget {
  const nasilNamazKilinir({Key? key}) : super(key: key);

  @override
  State<nasilNamazKilinir> createState() => _nasilNamazKilinirState();
}

class _nasilNamazKilinirState extends State<nasilNamazKilinir> {

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

  @override
  void initState() {
    // TODO: implement initState
    if (_interstitialAd != null) {
      _interstitialAd?.show();
    }else{
      print("içerik boş");
    }

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
        title: Text("Nasıl Namaz Kılınır?"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          children: [

            if (_bannerAd != null)
              Center(
                child: Container(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),

            listTileNamaz(iconText: Icon(Icons.info), textForListTile: "İki Rekatlık Namaz Nasıl Kılınır?", pageToNavigate: ikiRekat()),
            listTileNamaz(iconText: Icon(Icons.info), textForListTile: "Sabah Namazı Nasıl Kılınır?", pageToNavigate: sabahNamazi()),
            listTileNamaz(iconText: Icon(Icons.info), textForListTile: "Öğle Namazı Nasıl Kılınır?", pageToNavigate: ogleNamazi()),
            listTileNamaz(iconText: Icon(Icons.info), textForListTile: "İkindi Namazı Nasıl Kılınır?", pageToNavigate: ikindiNamazi()),
            listTileNamaz(iconText: Icon(Icons.info), textForListTile: "Akşam Namazı Nasıl Kılınır?", pageToNavigate: aksamNamazi()),
            listTileNamaz(iconText: Icon(Icons.info), textForListTile: "Yatsı Namazı Nasıl Kılınır?", pageToNavigate: yatsiNamazi()),
            listTileNamaz(iconText: Icon(Icons.info), textForListTile: "Cuma Namazı Namazı Nasıl Kılınır?", pageToNavigate: cumaNamazi()),
            listTileNamaz(iconText: Icon(Icons.info), textForListTile: "Bayram Namazı Nasıl Kılınır?", pageToNavigate: bayramNamazi()),


          ]
        ),
      ),
    );
  }
}



class ikiRekat extends StatefulWidget {
  const ikiRekat({Key? key}) : super(key: key);

  @override
  State<ikiRekat> createState() => _ikiRekatState();
}

class _ikiRekatState extends State<ikiRekat> {

    var htmldata = "<!DOCTYPE html><html><head><title>Namaz Kılma Rehberi</title></head><body><h1>Namaza Başlarken:</h1><p>- İlk olarak Niyet edilir 'Niyet ettim Allah rızası için bugünkü sabah namazının sünnetini kılmaya',</p><p>- 'Allahu Ekber' diyerek İftitah tekbiri alınır,</p><p>- Eller bağlanır ve namaza başlanır. (Erkekler; göbek altında sağ eli sol elin üzerine bağlarlar. Bayanlar; göğüs üzerinde sağ eli sol elin üzerine koyarlar)</p><h1>1. Rekat:</h1><p>- 'Sübhaneke' okunur,</p><p>- 'Euzü-Besmele' çekilir,</p><p>- 'Fatiha Suresi' okunur,</p><p>- 'Namaz Suresi' okunur,</p><p>- 'Allahü Ekber' diyerek 'Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken 'Semi Allahü Limen Hamideh', tam dik durunca ise 'Rabbena Lekel Hamd' denir,</p><p>- 'Allahü Ekber' diyerek iki defa 'Secde'ye gidilir ve üç defa 'Sübhane Rabbiyel-a'lâ' denir,</p><p>- 'Allahü Ekber' diyerek 'Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır.</p><h1>2. Rekat:</h1><p>- 'Besmele' çekilir,</p><p>- 'Fatiha Suresi' okunur,</p><p>- 'Namaz Suresi' okunur,</p><p>- 'Allahü Ekber' diyerek 'Rüku'a eğilinir,</p><p>- 'Allahü Ekber' diyerek iki defa 'Secde'ye gidilir,</p><p>- 'Ka'de-i ahire' yani son oturuşa geçilir,</p><p>- Oturuşta 'Ettahiyyatü' okunur,</p><p>- 'Allahümme Salli' okunur,</p><p>- 'Allahümme Barik' okunur,</p><p>- 'Rabbena Atina' okunur,</p><p>- 'Rabbena Firli' okunur,</p><p>- 'Esselamü Aleyküm Ve Rahmetullah' diye ilk önce başımız sağa çevrilmiş ve gözler omuza bakacak şekilde selam verilir, sonra da aynı şekilde sola selam verilerek namaz tamamlanır.</p><p>2 rekatlık bir namaz genel hatlarıyla anlattığımız gibi kılınır. Nitekim her vakit namaz, namazların sünnetleri ve farzları, erkeklerin ve bayanların farklı kılması gibi ayrıntıları ilgili bağlantılarımızı takip ederek öğrenebilirsiniz.</p><p>Namaz kılarken farzlarına, vaciplerine, sünnetlerine ve adabına riayet ederek kılmalıyız.</p><p>Peygamber Efendimiz (s.a.v.); 'Benim nasıl namaz kıldığımı görüyorsanız siz de öyle kılın.' (Buhari, Müslim)</p></body></html>";

  @override
  Widget build(BuildContext context) {
    return fullPageCreatorForPray(title: "İki Rekatlık Namaz Nasıl Kılınır?", backgroundColorForTitle: Colors.black38, htmlContent: "$htmldata");
  }
}



class sabahNamazi extends StatefulWidget {
  const sabahNamazi({Key? key}) : super(key: key);

  @override
  State<sabahNamazi> createState() => _sabahNamaziState();
}

class _sabahNamaziState extends State<sabahNamazi> {
  var htmlContent="<!DOCTYPE html><html><head><title>Namaz Kılma Rehberi</title></head><body><p>Sabah namazının ilk önce 2 rekat sünneti daha sonra 2 rekat farzı kılınır. Sabah namazı vakti, fecrin doğması ile başlayıp, güneşin doğması ile sona ermektedir. Sabah namazı nasıl kılınır detaylı olarak aşağıdan öğrenebilirsiniz.</p><p><strong>Sabah Namazı Kılınışı</strong></p><p><strong>2 Rekat Sünnet:</strong></p><p><strong>Namaza Başlarken</strong></p><ul><li>İlk olarak Niyet edilir ('Niyet ettim Allah rızası için bugünkü sabah namazının sünnetini kılmaya'),</li><li>'Allahu Ekber' diyerek İftitah tekbiri alınır,</li><li>Eller bağlanır ve namaza başlanır (Erkekler; göbek altında sağ eli sol elin üzerine bağlarlar. Bayanlar; göğüs üzerinde sağ eli sol elin üzerine koyarlar)...</li></ul><p><strong>1. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken 'Semi Allahü Limen Hamideh', tam dik durunca ise 'Rabbena Lekel Hamd' denir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir ve üç defa 'Sübhane Rabbiyel-a'lâ' denir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır...</li></ul><p><strong>2. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani son oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>Allahümme Salli okunur,</li><li>Allahümme Barik okunur,</li><li>Rabbena Atina okunur,</li><li>Rabbena Firli okunur,</li><li>'Esselamü Aleyküm Ve Rahmetullah' diye selam verilerek namaz tamamlanır.</li></ul><p><strong>2 Rekat Farz:</strong></p><p><strong>Namaza Başlarken</strong></p><ul><li>Namaza başlamadan önce Kamet getirilir (Sadece erkekler kamet getirir),</li><li>İlk olarak Niyet edilir ('Niyet ettim Allah rızası için bugünkü sabah namazının farzını kılmaya'),</li><li>'Allahü Ekber' diyerek İftitah tekbiri alınır,</li><li>Eller bağlanır ve namaza başlanır...</li></ul><p><strong>1. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken 'Semi Allahü Limen Hamideh', tam dik durunca ise 'Rabbena Lekel Hamd' denir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir ve üç defa 'Sübhane Rabbiyel-a'lâ' denir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır...</li></ul><p><strong>2. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani son oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>Allahümme Salli okunur,</li><li>Allahümme Barik okunur,</li><li>Rabbena Atina okunur,</li><li>Rabbena Firli okunur,</li><li>'Esselamü Aleyküm Ve Rahmetullah' diye selam verilerek namaz tamamlanır.</li></ul><p>Namazdan sonra Tesbihat yapılarak dua edilir.</p></body></html>";
  @override
  Widget build(BuildContext context) {
    return fullPageCreatorForPray(title: "Sabah Namazı Nasıl Kılınır?", htmlContent: htmlContent);
  }
}


/*
Öğle Namazı Nasıl Kılınır?
 */


class ogleNamazi extends StatefulWidget {
  const ogleNamazi({Key? key}) : super(key: key);

  @override
  State<ogleNamazi> createState() => _ogleNamaziState();
}

class _ogleNamaziState extends State<ogleNamazi> {
  var htmlContent="<!DOCTYPE html><html><head><title>Namaz Kılma Rehberi</title></head><body><p>Öğle namazının kılınışı</p><p><strong>4 Rekat İlk Sünnet:</strong></p><p><strong>Namaza Başlarken</strong></p><ul><li>İlk olarak Niyet edilir ('Niyet ettim Allah rızası için bugünkü öğle namazının ilk sünnetini kılmaya'),</li><li>'Allahu Ekber' diyerek İftitah tekbiri alınır,</li><li>Eller bağlanır ve namaza başlanır (Erkekler; göbek altında sağ eli sol elin üzerine bağlarlar. Bayanlar; göğüs üzerinde sağ eli sol elin üzerine koyarlar)...</li></ul><p><strong>1. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken 'Semi Allahü Limen Hamideh', tam dik durunca ise 'Rabbena Lekel Hamd' denir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir ve üç defa 'Sübhane Rabbiyel-a'lâ' denir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır...</li></ul><p><strong>2. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak üçüncü rekata başlanır...</li></ul><p><strong>3. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak dördüncü rekata başlanır...</li></ul><p><strong>4. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani son oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>Allahümme Salli okunur,</li><li>Allahümme Barik okunur,</li><li>Rabbena Atina okunur,</li><li>Rabbena Firli okunur,</li><li>'Esselamü Aleyküm Ve Rahmetullah' diye selam verilerek namaz tamamlanır.</li></ul><p><strong>4 Rekat Farz:</strong></p><p><strong>Namaza Başlarken</strong></p><ul><li>Namaza başlamadan önce Kamet getirilir (Sadece erkekler kamet getirir),</li><li>İlk olarak Niyet edilir ('Niyet ettim Allah rızası için bugünkü öğle namazının farzını kılmaya'),</li><li>'Allahü Ekber' diyerek İftitah tekbiri alınır,</li><li>Eller bağlanır ve namaza başlanır...</li></ul><p><strong>1. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken 'Semi Allahü Limen Hamideh' denir, tam dik durunca ise 'Rabbena Lekel Hamd' denir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir ve üç defa 'Sübhane Rabbiyel-a'lâ' denir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır...</li></ul><p><strong>2. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani son oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak üçüncü rekata başlanır...</li></ul><p><strong>3. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak dördüncü rekata başlanır...</li></ul><p><strong>4. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani son oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>Allahümme Salli okunur,</li><li>Allahümme Barik okunur,</li><li>Rabbena Atina okunur,</li><li>Rabbena Firli okunur,</li><li>'Esselamü Aleyküm Ve Rahmetullah' diye selam verilerek namaz tamamlanır.</li></ul><p><strong>2 Rekat Son Sünnet:</strong></p><p><strong>Namaza Başlarken</strong></p><ul><li>İlk olarak Niyet edilir ('Niyet ettim Allah rızası için bugünkü öğle namazının son sünnetini kılmaya'),</li><li>'Allahü Ekber' diyerek İftitah tekbiri alınır,</li><li>Eller bağlanır ve namaza başlanır...</li></ul><p><strong>1. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken 'Semi Allahü Limen Hamideh' denir, tam dik durunca ise 'Rabbena Lekel Hamd' denir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir ve üç defa 'Sübhane Rabbiyel-a'lâ' denir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır...</li></ul><p><strong>2. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani son oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak namaz tamamlanır.</li></ul><p>Namazdan sonra Tesbihat yapılarak dua edilir.</p></body></html>";
  @override
  Widget build(BuildContext context) {
    return fullPageCreatorForPray(title: "Öğle Namazı Nasıl Kılınır?", htmlContent: htmlContent);
  }
}

/*
İkindi Namazı Nasıl Kılınır?
 */

class ikindiNamazi extends StatefulWidget {
  const ikindiNamazi({Key? key}) : super(key: key);

  @override
  State<ikindiNamazi> createState() => _ikindiNamaziState();
}

class _ikindiNamaziState extends State<ikindiNamazi> {
  var htmlContent="<!DOCTYPE html><html><head><title>İkindi Namazı Kılma Rehberi</title></head><body><p>İkindi namazının kılınışı</p><p><strong>4 Rekat Sünnet:</strong></p><p><strong>Namaza Başlarken</strong></p><ul><li>İlk olarak Niyet edilir ('Niyet ettim Allah rızası için bugünkü ikindi namazının sünnetini kılmaya'),</li><li>'Allahu Ekber' diyerek İftitah tekbiri alınır,</li><li>Eller bağlanır ve namaza başlanır (Erkekler; göbek altında sağ eli sol elin üzerine bağlarlar. Bayanlar; göğüs üzerinde sağ eli sol elin üzerine koyarlar)...</li></ul><p><strong>1. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken 'Semi Allahü Limen Hamideh', tam dik durunca ise 'Rabbena Lekel Hamd' denir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir ve üç defa 'Sübhane Rabbiyel-a'lâ' denir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır...</li></ul><p><strong>2. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>Allahümme Salli okunur,</li><li>Allahümme Barik okunur,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak üçüncü rekata başlanır...</li></ul><p><strong>3. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak dördüncü rekata başlanır...</li></ul><p><strong>4. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani son oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>Allahümme Salli okunur,</li><li>Allahümme Barik okunur,</li><li>Rabbena Atina okunur,</li><li>Rabbena Firli okunur,</li><li>'Esselamü Aleyküm Ve Rahmetullah' diye selam verilerek namaz tamamlanır.</li></ul><p><strong>4 Rekat Farz:</strong></p><p><strong>Namaza Başlarken</strong></p><ul><li>Namaza başlamadan önce Kamet getirilir (Sadece erkekler kamet getirir),</li><li>İlk olarak Niyet edilir ('Niyet ettim Allah rızası için bugünkü ikindi namazının farzını kılmaya'),</li><li>'Allahü Ekber' diyerek İftitah tekbiri alınır,</li><li>Eller bağlanır ve namaza başlanır...</li></ul><p><strong>1. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken 'Semi Allahü Limen Hamideh' denir, tam dik durunca ise 'Rabbena Lekel Hamd' denir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir ve üç defa 'Sübhane Rabbiyel-a'lâ' denir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır...</li></ul><p><strong>2. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak üçüncü rekata başlanır...</li></ul><p><strong>3. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak dördüncü rekata başlanır...</li></ul><p><strong>4. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani son oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>Allahümme Salli okunur,</li><li>Allahümme Barik okunur,</li><li>Rabbena Atina okunur,</li><li>Rabbena Firli okunur,</li><li>'Esselamü Aleyküm Ve Rahmetullah' diye selam verilerek namaz tamamlanır.</li></ul><p>Namazdan sonra Tesbihat yapılarak dua edilir.</p></body></html>";
  @override
  Widget build(BuildContext context) {
    return fullPageCreatorForPray(title: "İkindi Namazı Nasıl Kılınır?", htmlContent: htmlContent);
  }
}



/*
Akşam Namazı
 */

class aksamNamazi extends StatefulWidget {
  const aksamNamazi({Key? key}) : super(key: key);

  @override
  State<aksamNamazi> createState() => _aksamNamaziState();
}

class _aksamNamaziState extends State<aksamNamazi> {
  var htmlContent = "<!DOCTYPE html><html><head><title>Akşam Namazı Kılma Rehberi</title></head><body><p>Akşam namazının kılınışı</p><p><strong>3 Rekat Farz:</strong></p><p><strong>Namaza Başlarken</strong></p><ul><li>Namaza başlamadan önce Kamet getirilir (Sadece erkekler kamet getirir),</li><li>İlk olarak Niyet edilir ('Niyet ettim Allah rızası için bugünkü akşam namazının farzını kılmaya'),</li><li>'Allahu Ekber' diyerek İftitah tekbiri alınır,</li><li>Eller bağlanır ve namaza başlanır (Erkekler; göbek altında sağ eli sol elin üzerine bağlarlar. Bayanlar; göğüs üzerinde sağ eli sol elin üzerine koyarlar)...</li></ul><p><strong>1. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Suresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken 'Semi Allahü Limen Hamideh', tam dik durunca ise 'Rabbena Lekel Hamd' denir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir ve üç defa 'Sübhane Rabbiyel-a'lâ' denir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır...</li></ul><p><strong>2. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak üçüncü rekata başlanır...</li></ul><p><strong>3. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani son oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>Allahümme Salli okunur,</li><li>Allahümme Barik okunur,</li><li>Rabbena Atina okunur,</li><li>Rabbena Firli okunur,</li><li>'Esselamü Aleyküm Ve Rahmetullah' diye selam verilerek namaz tamamlanır.</li></ul><p><strong>2 Rekat Sünnet:</strong></p><p><strong>Namaza Başlarken</strong></p><ul><li>İlk olarak Niyet edilir ('Niyet ettim Allah rızası için bugünkü akşam namazının sünnetini kılmaya'),</li><li>'Allahü Ekber' diyerek İftitah tekbiri alınır,</li><li>Eller bağlanır ve namaza başlanır...</li></ul><p><strong>1. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken 'Semi Allahü Limen Hamideh' denir, tam dik durunca ise 'Rabbena Lekel Hamd' denir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir ve üç defa 'Sübhane Rabbiyel-a'lâ' denir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır...</li></ul><p><strong>2. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani son oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>Allahümme Salli okunur,</li><li>Allahümme Barik okunur,</li><li>Rabbena Atina okunur,</li><li>Rabbena Firli okunur,</li><li>'Esselamü Aleyküm Ve Rahmetullah' diye selam verilerek namaz tamamlanır.</li></ul><p>Namazdan sonra Tesbihat yapılarak dua edilir.</p></body></html>";
  @override
  Widget build(BuildContext context) {
    return fullPageCreatorForPray(title: "Akşam Namazı Nasıl Kılınır? ", htmlContent: htmlContent);
  }
}



/*
Yatsı Namazı
 */


class yatsiNamazi extends StatefulWidget {
  const yatsiNamazi({Key? key}) : super(key: key);

  @override
  State<yatsiNamazi> createState() => _yatsiNamaziState();
}

class _yatsiNamaziState extends State<yatsiNamazi> {
  var htmlContent = "<!DOCTYPE html><html><head><title>Yatsı Namazı Kılma Rehberi</title></head><body><p>Yatsı namazının kılınışı</p><p><strong>4 Rekat İlk Sünnet:</strong></p><p><strong>Namaza Başlarken</strong></p><ul><li>İlk olarak Niyet edilir ('Niyet ettim Allah rızası için bugünkü yatsı namazının ilk sünnetini kılmaya'),</li><li>'Allahu Ekber' diyerek İftitah tekbiri alınır,</li><li>Eller bağlanır ve namaza başlanır (Erkekler; göbek altında sağ eli sol elin üzerine bağlarlar. Bayanlar; göğüs üzerinde sağ eli sol elin üzerine koyarlar)...</li></ul><p><strong>1. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken 'Semi Allahü Limen Hamideh', tam dik durunca ise 'Rabbena Lekel Hamd' denir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir ve üç defa 'Sübhane Rabbiyel-a'lâ' denir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır...</li></ul><p><strong>2. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>Allahümme Salli okunur,</li><li>Allahümme Barik okunur,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak üçüncü rekata başlanır...</li></ul><p><strong>3. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak dördüncü rekata başlanır...</li></ul><p><strong>4. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani son oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>Allahümme Salli okunur,</li><li>Allahümme Barik okunur,</li><li>Rabbena Atina okunur,</li><li>Rabbena Firli okunur,</li><li>'Esselamü Aleyküm Ve Rahmetullah' diye selam verilerek namaz tamamlanır.</li></ul><p><strong>4 Rekat Farz:</strong></p><p><strong>Namaza Başlarken</strong></p><ul><li>Namaza başlamadan önce Kamet getirilir (Sadece erkekler kamet getirir),</li><li>İlk olarak Niyet edilir ('Niyet ettim Allah rızası için bugünkü yatsı namazının farzını kılmaya'),</li><li>'Allahu Ekber' diyerek İftitah tekbiri alınır,</li><li>Eller bağlanır ve namaza başlanır...</li></ul><p><strong>1. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken 'Semi Allahü Limen Hamideh' denir, tam dik durunca ise 'Rabbena Lekel Hamd' denir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir ve üç defa 'Sübhane Rabbiyel-a'lâ' denir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır...</li></ul><p><strong>2. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allah";
  @override
  Widget build(BuildContext context) {
    return fullPageCreatorForPray(title: "Yatsı Namazı Nasıl Kılınır?", htmlContent: htmlContent);
  }
}

/*
Cuma Namazı
 */

class cumaNamazi extends StatefulWidget {
  const cumaNamazi({Key? key}) : super(key: key);

  @override
  State<cumaNamazi> createState() => _cumaNamaziState();
}

class _cumaNamaziState extends State<cumaNamazi> {
  var htmlContent = "<!DOCTYPE html><html><head><title>Cuma Namazı Kılma Rehberi</title></head><body><p>4 Rekat Cumanın İlk Sünneti:</p><p><strong>Namaza Başlarken</strong></p><ul><li>İlk olarak Niyet edilir ('Niyet ettim Allah rızası için bugünkü cuma namazının ilk sünnetini kılmaya'),</li><li>'Allahu Ekber' diyerek İftitah tekbiri alınır,</li><li>Eller bağlanır ve namaza başlanır (Erkekler; göbek altında sağ eli sol elin üzerine bağlarlar)...</li></ul><p><strong>1. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>Euzü-Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken 'Semi Allahü Limen Hamideh', tam dik durunca ise 'Rabbena Lekel Hamd' denir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir ve üç defa 'Sübhane Rabbiyel-a'lâ' denir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır...</li></ul><p><strong>2. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak üçüncü rekata başlanır...</li></ul><p><strong>3. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>'Allahü Ekber' diyerek Kıyam'a geçilir yani ayağa kalkılarak dördüncü rekata başlanır...</li></ul><p><strong>4. Rekat</strong></p><ul><li>Besmele çekilir,</li><li>Fatiha Sûresi okunur,</li><li>Namaz Sûresi okunur,</li><li>'Allahü Ekber' diyerek Rüku'a eğilinir,</li><li>'Allahü Ekber' diyerek iki defa Secde'ye gidilir,</li><li>Ka'de-i ahîre yani son oturuşa geçilir,</li><li>Oturuşta Ettahiyyâtü okunur,</li><li>Allahümme Salli okunur,</li><li>Allahümme Barik okunur,</li><li>Rabbena Atina okunur,</li><li>Rabbena Firli okunur,</li><li>'Esselamü Aleyküm Ve Rahmetullah' diye selam verilerek namaz tamamlanır.</li></ul><p>2 Rekat Cumanın Farzı:</p><p><strong>Namaza Başlarken</strong></p><ul><li>İlk sünnet kılındıktan ve imam minbere çıkıp oturduktan sonra, müezzin cami içinde ikinci ezanı okur.</li><li>İmam hutbeyi okur ve dua eder. Daha sonra müezzin kamet getirir ve cuma namazın farzı için herkes ayağa kalkar.</li><li>İlk olarak Niyet edilir 'Niyet ettim Allah rızası için bugünkü cuma namazının farzını kılmaya, uydum hazır olan imama',</li><li>'Allahu Ekber' diyerek imam İftitah tekbiri alır, bizde kendi içimizden tekbir alırız,</li><li>Eller bağlanır ve namaza başlanır...</li></ul><p><strong>1. Rekat</strong></p><ul><li>Sübhaneke okunur,</li><li>İmam Fatiha suresi ve namaz suresi okur, bizde imamı dinleriz,</li><li>İmam 'Allahü Ekber' der ve 'Rüku'a eğilinir ve üç defa 'Sübhane Rabbiye'l-Azim' denir. Rükudan doğrulurken imam 'Semi Allahü Limen Hamideh' der, tam dik durunca bizde 'Rabbena Lekel Hamd' deriz,</li><li>İmam 'Allahü Ekber' der ve iki defa 'Secde'ye gidilir ve secdede üçer defa 'Sübhane Rabbiyel-a'lâ' deriz,</li><li>İmam 'Allahü Ekber' der ve 'Kıyam'a geçilir yani ayağa kalkılarak ikinci rekata başlanır...</li></ul><p><strong>2. Rekat</strong></p><ul><li>İmam Fatiha suresi ve namaz suresi okur, bizde imamı dinleriz,</li><li>İmam 'Allahü Ekber' der ve '";
  @override
  Widget build(BuildContext context) {
    return fullPageCreatorForPray(title: "Cuma Namazı Nasıl Kılınır?", htmlContent: htmlContent);
  }
}


//Bayram Namazı Nasıl Kılınır?



class bayramNamazi extends StatefulWidget {
  const bayramNamazi({Key? key}) : super(key: key);

  @override
  State<bayramNamazi> createState() => _bayramNamaziState();
}

class _bayramNamaziState extends State<bayramNamazi> {
  var htmlContent = "<!DOCTYPE html><html><head><title>Bayram Namazı Kılma Rehberi</title></head><body><p>Bayram namazları, müslümanlar arasindaki birlik ve beraberligin güzel bir göstergesi olarak bayramların birinci günü, kuşluk vaktinde kılınır. Bayram namazı farz değil vaciptir. İki rekat olarak cemaatle kılınır.</p><p>Vacip oluşunun ve kılınmasının şartları, aynen Cuma namazının şartları gibidir. Bayram namazında ezan okunmaz, kamet yapılmaz.</p><p>Ramazan Bayramı ve Kurban Bayramı olmak üzere yılda iki kez bayram namazı kılınır. Ramazan ve Kurban bayramının birinci günü kılınır.</p><p>Bayram namazı aşağıdaki şekilde kılınır</p><ul><li>Önce Niyet ettim vacip olan bayram namazını kılmaya, uydum hazır olan imama diye niyet edilerek namaza durulur.</li><li>Sonra Sübhaneke okunur.</li><li>Sübhanekeden sonra eller üç defa tekbir getirerek kulaklara kaldırılıp (iftitah tekbirinde oldugu gibi), birinci ve ikincisinde iki yana bırakılır. Üçüncüsünde, göbek altına bağlanır. İmam önce Fatiha, sonra bir sure okur ve beraberce rükuya eğilinir.</li><li>Rüku ve secdeler yapılarak ayağa (ikinci rekata) kalkılır ve eller bağlanır.</li><li>İkinci rekatta, imam önce Fatiha ve bir sure okur. Sonra iki el üç defa tekbir getirerek kaldırılır. Üçüncüde de yanlara bırakılır. Dördüncü tekbirde elleri kulaklara kaldırmayıp, rükuya eğilinir.</li><li>Sonra da secdeler yapılarak oturulur.</li><li>Oturuşta imam ve cemaat, Ettehiyyatü, Allahümme salli, Allahümme barik ve Rabbena atina, Rabbena firli duasını okuyarak önce sağa, sonra sola selam verip namaz bitirilir.</li></ul></body></html>";
  @override
  Widget build(BuildContext context) {
    return fullPageCreatorForPray(title: "Bayram Namazı Nasıl Kılınır?", htmlContent: htmlContent);
  }
}
