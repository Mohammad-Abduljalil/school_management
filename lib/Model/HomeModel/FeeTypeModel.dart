class FeeTypeModel {
  final int id;
  final String name;
  final double defaultAmount;

  FeeTypeModel({
    required this.id,
    required this.name,
    required this.defaultAmount,
  });

  factory FeeTypeModel.fromJson(Map<String, dynamic> json) {
    return FeeTypeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      defaultAmount: double.tryParse(json['default_amount']?.toString() ?? '0') ?? 0,
    );
  }
}
