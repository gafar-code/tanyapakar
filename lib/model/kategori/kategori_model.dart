class Kategori {
  String idKategori;
  String namaKategori;
  String coverKategori;
  String deskripsiKategori;
  String jmlPakar;

  Kategori({
    required this.idKategori,
    required this.namaKategori,
    required this.coverKategori,
    required this.deskripsiKategori,
    required this.jmlPakar,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) => Kategori(
        idKategori: json["id_kategori"],
        namaKategori: json["nama_kategori"],
        coverKategori: json["cover_kategori"],
        deskripsiKategori: json["deskripsi_kategori"],
        jmlPakar: json["jmlPakar"],
      );
}
