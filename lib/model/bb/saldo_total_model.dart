class SaldoTotal {
  String total;

  SaldoTotal({
    required this.total,
  });

  factory SaldoTotal.fromJSON(Map<String, dynamic> json) => SaldoTotal(
        total: json["total"],
      );
}
