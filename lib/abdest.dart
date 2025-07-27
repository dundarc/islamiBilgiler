import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:islamibilgiler/ad_helper.dart';
import 'package:islamibilgiler/widget/htmlViewer.dart';





class abdestNasilAlinir extends StatefulWidget {
  const abdestNasilAlinir({Key? key}) : super(key: key);

  @override
  State<abdestNasilAlinir> createState() => _abdestNasilAlinirState();
}

class _abdestNasilAlinirState extends State<abdestNasilAlinir> {


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
    var genislik= MediaQuery.of(context).size.width;
    var yukseklik= MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Abdest Nasıl Alınır?"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Center(child: Image.asset("assets/images/abdest.jpg")),
            htmlViewer(html: "<!DOCTYPE html><html><head><title>Abdest Alma Rehberi</title></head><body><p>ABDEST NASIL ALINIR?</p><ol><li>Önce kollar dirseklerin yukarısı na kadar sıvanır, sonra Niyet ettim Allah rızası için abdest almaya diye niyet edilir. Ve Eûzü billahi mineşşeytanirracîm, Bismillahirrahmanirrahîm okunur.</li><li>Eller bileklere kadar üç kere yıkanır. Parmak aralarının yıkanmasına dikkat edilir. Parmaklarda yüzük varsa oynatılıp altının yıkanması sağlanır.</li><li>Sağ avuç ile ağıza üç kere ayrı ayrı su alınıp her defasında iyice çalkalanır.</li><li>Sağ avuç ile buruna üç kere ayrı ayrı su çekilir.</li><li>Sol el ile sümkürülerek burun temizlenir.</li><li>Alında saçların bittiği yerden itibaren kulakların yumuşağına ve çene altına kadar yüzün her tarafı üç kere yıkanır.</li><li>Sağ kol dirseklerle beraber üç kere yıkanır. Yıkarken kolun her tarafı, kuru bir yer kalmayacak şekilde iyice ovulur.</li><li>Sol kol dirseklerle beraber üç kere yıkanır. Yıkarken kolun her tarafı, kuru bir yer kalmayacak şekilde iyice ovulur.</li><li>Eller yeni bir su ile ıslatılır. Sağ elin içi ve parmaklar başın üzerine konularak bir kere meshedilir.</li><li>Eller ıslatılarak sağ elin şehadet parmağı ile sağ kulağın içi, baş parmağı ile de kulağın dışı; sol elin şehadet parmağı ile sol kulağın içi, baş parmağı ile de kulağın arkası meshedilir.</li><li>Elleri yeniden ıslatmaya gerek olmadan geriye kalan üçer parmağın dışı ile de boyun meshedilir.</li><li>Sağ ayak üç kere topuklarla beraber yıkanır. Yıkamaya parmak uçlarından başlanır ve parmak araları iyice temizlenir.</li><li>Sol ayak topuklarla beraber yıkanır. Yıkamaya parmak uçlarından başlanır ve parmak araları iyice temizlenir.</li></ol><p>Abdest bitince ayakta ve kıbleye karşı Kelime-i Şehadet okunur.</p></body></html>"),
            Column(
              children: [
                Container(
                  width: genislik,
                  color: Colors.black,

                  child: ListView(

                    shrinkWrap: true,
                    children: [
                      ListTile(
                        style: ListTileStyle.list,
                        title: Text("Abdest'in Farzları Nelerdir?",
                          style: TextStyle(
                            color: Colors.white
                          )),
                        onTap: () {

                          var htmlData="<!DOCTYPE html><html><head><title>Abdestin Farzları</title></head><body><p>Sünni alimlere göre abdestin farzları dörttür:</p><ul><li>Başın dörtte birini meshetmek, yani ıslak elle sıvazlamak.</li><li>Kolları (dirsekleriyle beraber) yıkamak.</li><li>Yüzü yıkamak.</li><li>Ayakları (topuklarıyla beraber) yıkamak.</li></ul><p>Şia alimlerden bazıları ayaklara meshetmenin abdestin farzlarından olduğuna, bazı alimler meshin farz, yıkamanın sünnet olduğuna, diğer bir kısmı ise her iki uygulamadan birisini yerine getirmenin yeterli olacağına inanmışlardır.</p></body></html>";

                         Navigator.push(context, MaterialPageRoute(builder: (context) => hizliEkran(title: "Abdest'in Farzları Nelerdir?", htmlData: htmlData)));

                        }
                      ),
                      ListTile(
                          style: ListTileStyle.list,
                          title: Text("Abdest'in Sünnetleri Nelerdir?",
                              style: TextStyle(
                                  color: Colors.white
                              )),
                          onTap: () {
                            var htmlData="<!DOCTYPE html><html><head><title>Abdestin Sünnetleri</title></head><body><h1>ABDESTİN SÜNNETLERİ NELERDİR?</h1><ul><li>Şadırvan</li><li>Niyet etmek</li><li>Eûzü ve Besmele ile başlamak</li><li>Evvela ellerini bileklerine kadar yıkamak</li><li>Misvak kullanmak</li><li>Bir âzâ kurumadan diğerini yıkamak</li><li>Ağzına ve burnuna üç kere su vermek</li><li>Kulağını meshetmek</li><li>Parmaklarını hilâllemek; yâni bir elin parmaklarını diğer elin parmakları arasına geçirip çekmek</li><li>Âzâları üçer kere yıkamak</li><li>Başını kaplama meshetmek</li><li>Abdesti tertip üzere almak; yâni abdest âzâlarını sırasıyla yıkamak</li><li>El ve ayaklarını yıkamakta parmak uçlarından başlamak</li><li>Abdest alırken okunacak birçok duâ olmakla beraber evlâ olan bütün âzâlarını yıkarken besmele çekip şehâdet getirmektir</li></ul></body></html>";



                            Navigator.push(context, MaterialPageRoute(builder: (context) => hizliEkran(title: "Abdest'in Sünnetleri Nelerdir?", htmlData: htmlData)));

                          }
                      ),
                      ListTile(
                          style: ListTileStyle.list,
                          title: Text("Abdest'in Mekruhları Nelerdir?",
                              style: TextStyle(
                                  color: Colors.white
                              )),
                          onTap: () {
                            var htmlData="<!DOCTYPE html><html><head><title>Abdestin Mekruhları</title></head><body><h1>ABDESTİN MEKRUHLARI</h1><ul><li>Sağ el ile sümkürmek</li><li>Abdest âzâlarından birini üç defadan az veya fazla yıkamak</li><li>Suyu yüzüne çarpmak</li><li>Güneşte ısınmış su ile abdest almak</li><li>Suyu çok az kullanmak veya israf etmek</li><li>Abdest alırken konuşmak</li><li>Sünnetlerini terk etmek</li></ul></body></html>";



                            Navigator.push(context, MaterialPageRoute(builder: (context) => hizliEkran(title: "Abdest'in Mekruhları Nelerdir?", htmlData: htmlData)));

                          }
                      ),
                      ListTile(
                          style: ListTileStyle.list,
                          title: Text("Abdest'i Bozan Durumlar Nelerdir?",
                              style: TextStyle(
                                  color: Colors.white
                              )),
                          onTap: () {
                            var htmlData="<!DOCTYPE html><html><head><title>Abdest Bozan Durumlar</title></head><body><h1>ABDEST BOZAN DURUMLAR NELERDİR?</h1><p>Nisa Suresi, 43 ayetine göre sekerat (şuuru yerinde olmamak: delilik/cinnet, esriklik/sarhoşluk, bayılmak-baygınlık, uyku-uyumak...) durumu ile boşaltım organlarından çıkış olması durumu namaza dolayısıyla da abdestin varlığına engeldir. Maise Suresi 6. ayetine göre namaz için abdest ya da teyemmüm şarttır.</p><p>Boşaltım organlarından idrar, kan, meni, gaita (dışkı), yel gibi katı, sıvı veya gaz çıkması,</p><p>Uyumak, delirmek, bayılmak, sarhoş olmak gibi idrak gücünün kaybedildiği durumlar,</p><p>Kanama,</p><p>Cinsî münasebet,</p><p>Ağız dolusu kusmak,</p><p>Teyemmüm almış birinin su bulması.</p></body></html>";

                            Navigator.push(context, MaterialPageRoute(builder: (context) => hizliEkran(title: "Abdest'i Bozan Durumlar Nelerdir?", htmlData: htmlData)));

                          }
                      ),
                      ListTile(
                          style: ListTileStyle.list,
                          title: Text("Diğer Konular",
                              style: TextStyle(
                                  color: Colors.white
                              )),
                          onTap: () {
                            var htmlData ="<!DOCTYPE html><html><head><title>Abdest Bozulduğunda Yapılması Gerekenler</title></head><body><h1>CEMAATLE NAMAZ KILAN BİRİNİN ABDESTİ BOZULURSA NE YAPMALIDIR?</h1><p>Cemaatle namaz kılan kimsenin abdesti bozulursa, abdest alıp yeniden namazını kılar ki faziletli olan budur. Ya da namazı bozacak başka bir şey yapmaksızın çıkıp abdest alır ve geri dönüp imam ile bıraktığı yerden namazına devam eder. Şayet imam namazı bitirmiş ise kalan rekâtlarda imama uymuş kimse gibi bir şey okumadan, yaklaşık olarak imamın bekleyeceği kadar bekler, sadece rükû ve secdedeki tesbihleri, oturuştaki dua ve salavatları okuyarak namazını tamamlar (Merğînânî, el-Hidâye, I, 381,382, İbn Âbidîn, Reddü’l-Muhtar, 368 vd.).</p><p>Kalabalık bir camide cemaatle namaz kılarken abdesti bozulan ön saftaki bir kişi, eğer abdesti bazı mezheplere göre bozulmamış sayılabilecekse o mezhebi taklit ederek namazına devam eder.</p><p>Mesela bir yeri kanayan Hanefî bir kişi, kanın abdesti bozmadığını söyleyen Şâfiî ve diğer mezhepleri taklit ederek namazını tamamlar. Fakat mesela idrar veya gaz çıkması gibi bütün müctehitlere göre abdesti bozan bir durum gerçekleşmişse ve kalabalıktan dolayı abdest alma yerine gitmeye de imkân bulamazsa, oturur ve namazın bitmesini bekler veya diğer namaz kılanların dikkatini dağıtmamak için hiçbir şey olmamış gibi hareket eder. Sonra abdest alıp namazını iade eder.</p><h1>ABDEST ALIRKEN KONUŞMANIN SAKINCASI VAR MIDIR?</h1><p>Abdest veya guslederken konuşmak abdeste veya gusle zarar vermez. Ancak bir ihtiyaç olmadıkça konuşmak uygun değildir. Abdest veya gusül almaya başlayan kişi, yaptığı ibadete odaklanmalı, dünyevi meşguliyet, duygu ve düşüncelerden mümkün olduğunca uzaklaşmalıdır (Şürünbülâlî, Merâkı’l-felâh, I, s. 44).</p></body></html>";

                            Navigator.push(context, MaterialPageRoute(builder: (context) => hizliEkran(title: "Diğer Konular", htmlData: htmlData)));

                          }
                      ),
                    ]
                  ),
                ),
              ],
            )


          ],
        ),
      ),
    );
  }
}


class hizliEkran extends StatefulWidget {
  final String title;
  final String htmlData;
  hizliEkran({required this.title, required this.htmlData});

  @override
  State<hizliEkran> createState() => _hizliEkranState();
}

class _hizliEkranState extends State<hizliEkran> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: htmlViewer(html: widget.htmlData),
    );
  }
}
