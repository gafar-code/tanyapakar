class MyKategori {
  String idKategori;
  String namaKategori;
  String coverKategori;
  String desKategori;
  String jasa;

  MyKategori({
    required this.idKategori,
    required this.namaKategori,
    required this.coverKategori,
    required this.desKategori,
    required this.jasa,
  });

  factory MyKategori.fromJson(Map<String, dynamic> json) => MyKategori(
        idKategori: json["idKategori"],
        namaKategori: json["namaKategori"],
        coverKategori: json["coverKategori"],
        desKategori: json["desKategori"],
        jasa: json["jasa"],
      );
}
