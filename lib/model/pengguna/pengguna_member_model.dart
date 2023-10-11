class PenggunaMember {
  String idPengguna;
  String namaPengguna;
  String avatarPengguna;
  String jenisPengguna;
  String nickName;
  String email;
  String tersedia;
  String? hp;
  String pwd;
  String? namaBank;
  String? idBank;
  String? nikSim;
  String? lahirTanggal;
  String? tempatLahir;
  String? noRek;
  String? noRef;

  PenggunaMember({
    required this.idPengguna,
    required this.namaPengguna,
    required this.avatarPengguna,
    required this.jenisPengguna,
    required this.nickName,
    required this.email,
    required this.hp,
    required this.pwd,
    required this.tersedia,
    this.namaBank,
    this.idBank,
    this.nikSim,
    this.lahirTanggal,
    this.tempatLahir,
    this.noRek,
    this.noRef,
  });

  factory PenggunaMember.fromJSON(Map<String, dynamic> json) => PenggunaMember(
        idPengguna: json["idPengguna"],
        namaPengguna: json["namaPengguna"],
        avatarPengguna: json["avatarPengguna"],
        jenisPengguna: json["jenisPengguna"],
        nickName: json["nickName"],
        email: json["email"],
        hp: json["hp"],
        lahirTanggal: json["lahirTanggal"],
        tempatLahir: json["tempatLahir"],
        noRek: json["noRek"],
        idBank: json["idBank"],
        nikSim: json["nikSim"],
        pwd: json["pwd"],
        namaBank: json["namaBank"],
        tersedia: json["tersedia"],
        noRef: json["kodeRef"],
      );

  Map<String, dynamic> toJSON() => {
        "namaPengguna": namaPengguna,
        "email": email,
        "hp": hp,
      };
}
