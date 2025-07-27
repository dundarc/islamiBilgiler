import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamibilgiler/widget/htmlViewer.dart';

class infoApp extends StatefulWidget {
  const infoApp({Key? key}) : super(key: key);

  @override
  State<infoApp> createState() => _infoAppState();
}

class _infoAppState extends State<infoApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İslami Bilgiler"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("İslami Bilgiler"),
            Text("Versiyon 1.0"),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => gizlilikPolitikasi()));
            }, child:
            Text("Gizlilik Politikası")
            )
          ],
        ),
      ),
    );
  }
}

class gizlilikPolitikasi extends StatefulWidget {
  const gizlilikPolitikasi({Key? key}) : super(key: key);

  @override
  State<gizlilikPolitikasi> createState() => _gizlilikPolitikasiState();
}

class _gizlilikPolitikasiState extends State<gizlilikPolitikasi> {
  String fileContent = ''; // Dosya içeriğini tutmak için değişken

  @override
  void initState() {
    super.initState();
    _loadFileContent(); // Dosya içeriğini yükle
  }

  Future<void> _loadFileContent() async {
    try {
      String content = await rootBundle.loadString("/textDosyalari/gizlilikPolitikasi.txt");
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
        title: Text("Gizlilik Politikası", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Tooltip(
              message: "Geri",
                child:
                Icon(Icons.arrow_back, color: Colors.white,))),

      ),
      body: htmlViewer(html: fileContent,),
    );
  }
}

