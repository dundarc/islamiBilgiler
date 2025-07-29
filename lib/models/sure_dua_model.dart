class SureDua {
  final String baslik;
  final String arapca;
  final String okunusu;
  final String anlami;

  SureDua({
    required this.baslik,
    required this.arapca,
    required this.okunusu,
    required this.anlami,
  });

  factory SureDua.fromJson(Map<String, dynamic> json) {
    return SureDua(
      baslik: json['baslik'] ?? '',
      arapca: json['arapca'] ?? '',
      okunusu: json['okunusu'] ?? '',
      anlami: json['anlami'] ?? '',
    );
  }
}