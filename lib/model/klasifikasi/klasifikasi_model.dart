class Klasifikasi {
  String idKlasifikasi;
  String idKategori;
  String namaKlasifikasi;
  String coverKlasifikasi;
  String namaKategori;
  String jasa;
  String deskripsiKlasifikasi;
  String? imgSerti1, imgSerti2, imgSerti3;
  String rating;
  String jmlKonsultasi;
  String deskripsiKategori;

  Klasifikasi({
    required this.idKlasifikasi,
    required this.idKategori,
    required this.namaKlasifikasi,
    required this.coverKlasifikasi,
    required this.jasa,
    required this.namaKategori,
    required this.deskripsiKlasifikasi,
    this.imgSerti1,
    this.imgSerti2,
    this.imgSerti3,
    required this.rating,
    required this.jmlKonsultasi,
    required this.deskripsiKategori,
  });

  factory Klasifikasi.fromJSON(Map<String, dynamic> json) => Klasifikasi(
        idKlasifikasi: json["idKlasifikasi"],
        idKategori: json["idKategori"],
        namaKlasifikasi: json["namaKlasifikasi"],
        coverKlasifikasi: json["coverKlasifikasi"],
        jasa: json["jasa"],
        namaKategori: json["namaKategori"],
        deskripsiKlasifikasi: json["deskripsiKlasifikasi"],
        imgSerti1: json["imgSerti1"],
        imgSerti2: json["imgSerti2"],
        imgSerti3: json["imgSerti3"],
        rating: json["rating"],
        jmlKonsultasi: json["jmlKonsultasi"],
        deskripsiKategori: json["deskripsiKategori"],
      );
}
