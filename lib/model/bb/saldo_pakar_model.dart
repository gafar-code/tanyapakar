class SaldoPakar {
  String idPakar, debet, kredit, tgl, nickName, imgAvatar;

  SaldoPakar({
    required this.idPakar,
    required this.debet,
    required this.kredit,
    required this.tgl,
    required this.nickName,
    required this.imgAvatar,
  });

  factory SaldoPakar.fromJSON(Map<String, dynamic> json) => SaldoPakar(
        idPakar: json["idPakar"],
        debet: json["debet"],
        kredit: json["kredit"],
        tgl: json["tgl"],
        nickName: json["nickName"],
        imgAvatar: json["imgAvatar"],
      );
}
