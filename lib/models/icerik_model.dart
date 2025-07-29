class Icerik {
  final String baslik;
  final String icerik;

  Icerik({required this.baslik, required this.icerik});

  factory Icerik.fromJson(Map<String, dynamic> json) {
    return Icerik(
      baslik: json['baslik'] ?? '',
      icerik: json['icerik'] ?? '',
    );
  }
}