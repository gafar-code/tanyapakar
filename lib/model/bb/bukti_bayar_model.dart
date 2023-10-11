class BuktiBayar {
  String idBuktiBayar,
      namaPengguna,
      avatarPengguna,
      imgBukti,
      nickName,
      email,
      hp,
      tgl,
      jumlah,
      aktif;

  BuktiBayar({
    required this.idBuktiBayar,
    required this.namaPengguna,
    required this.avatarPengguna,
    required this.imgBukti,
    required this.nickName,
    required this.email,
    required this.hp,
    required this.tgl,
    required this.jumlah,
    required this.aktif,
  });

  factory BuktiBayar.fromJSON(Map<String, dynamic> json) => BuktiBayar(
        idBuktiBayar: json["idBuktiBayar"],
        namaPengguna: json["namaPengguna"],
        avatarPengguna: json["avatarPengguna"],
        imgBukti: json["imgBukti"],
        nickName: json["nickName"],
        email: json["email"],
        hp: json["hp"],
        tgl: json["tgl"],
        jumlah: json["jumlah"],
        aktif: json["aktif"],
      );
}
