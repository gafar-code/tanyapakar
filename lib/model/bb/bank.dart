class Banks {
  String idBank, namaBank;

  Banks({
    required this.idBank,
    required this.namaBank,
  });

  factory Banks.fromJSON(Map<String, dynamic> json) =>
      Banks(idBank: json["idBank"], namaBank: json["namaBank"]);
}
