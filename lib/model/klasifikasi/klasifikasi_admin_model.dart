class KlasifikasiAdmin {
  String idKlasifikasi;
  String namaKlasifikasi;
  String coverKlasifikasi;
  String idKategori;
  String namaKategori;
  String coverKategori;
  String nickName;
  String pemilik;
  String hp;
  String email;

  KlasifikasiAdmin({
    required this.idKlasifikasi,
    required this.namaKlasifikasi,
    required this.coverKlasifikasi,
    required this.idKategori,
    required this.namaKategori,
    required this.coverKategori,
    required this.nickName,
    required this.pemilik,
    required this.hp,
    required this.email,
  });

  factory KlasifikasiAdmin.fromJSON(Map<String, dynamic> json) =>
      KlasifikasiAdmin(
        idKlasifikasi: json["idKlasifikasi"],
        namaKlasifikasi: json["namaKlasifikasi"],
        coverKlasifikasi: json["coverKlasifikasi"],
        idKategori: json["idKategori"],
        namaKategori: json["namaKategori"],
        coverKategori: json["coverKategori"],
        nickName: json["nickName"],
        pemilik: json["pemilik"],
        hp: json["hp"],
        email: json["email"],
      );
}
