class NormaData {
  String  idNorma, isiNorma;

  NormaData({
    required this.idNorma,
    required this.isiNorma,    
  });

  factory NormaData.fromJson(Map<String, dynamic> json) => NormaData(
        idNorma: json["idNorma"],
        isiNorma: json["isiNorma"],
      );

}
