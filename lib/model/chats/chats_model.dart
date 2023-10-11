class MessageData {
  String kepada, dari, msg, time;
  int? jenis;

  MessageData({
    required this.kepada,
    required this.dari,
    required this.msg,
    required this.time,
    this.jenis,
  });


  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
        kepada: json["kepada"],
        dari: json["dari"],
        msg: json["msg"],
        time: json["time"],
        jenis: json["jenis"],
      );

}
