class KlasifikasiPakar {
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
  String idPenggunaPakar;
  String nickName;
  String imgAvatar;
  String tersedia;

  KlasifikasiPakar({
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
    required this.idPenggunaPakar,
    required this.nickName,
    required this.imgAvatar,
    required this.tersedia,
  });

  factory KlasifikasiPakar.fromJSON(Map<String, dynamic> json) =>
      KlasifikasiPakar(
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
        idPenggunaPakar: json["idPenggunaPakar"],
        nickName: json["nickName"],
        imgAvatar: json["imgAvatar"],
        tersedia: json["tersedia"],
      );
}
