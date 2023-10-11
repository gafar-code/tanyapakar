class MemberKlasifikasi {
  String idKlasifikasi;
  String idKategori;
  String coverKlasifikasi;
  String imgAvatar;
  String namaKlasifikasi;
  String nickName;
  String deskripsiPakar;
  String tersedia;
  String rating;
  String jmlKonsultasi;
  String idPakar;
  String idPenggunaPakar;
  String jasa;

  MemberKlasifikasi({
    required this.idKlasifikasi,
    required this.idKategori,
    required this.coverKlasifikasi,
    required this.imgAvatar,
    required this.namaKlasifikasi,
    required this.nickName,
    required this.deskripsiPakar,
    required this.tersedia,
    required this.rating,
    required this.jmlKonsultasi,
    required this.idPakar,
    required this.idPenggunaPakar,
    required this.jasa,
  });

  factory MemberKlasifikasi.fromJSON(Map<String, dynamic> json) =>
      MemberKlasifikasi(
          idKlasifikasi: json["idKlasifikasi"],
          idKategori: json["idKategori"],
          coverKlasifikasi: json["coverKlasifikasi"],
          imgAvatar: json["imgAvatar"],
          namaKlasifikasi: json["namaKlasifikasi"],
          nickName: json["nickName"],
          deskripsiPakar: json["deskripsiPakar"],
          tersedia: json["tersedia"],
          rating: json["rating"],
          jmlKonsultasi: json["jmlKonsultasi"],
          idPakar: json["idPakar"],
          idPenggunaPakar: json["idPenggunaPakar"],
          jasa: json["jasa"]);
}
