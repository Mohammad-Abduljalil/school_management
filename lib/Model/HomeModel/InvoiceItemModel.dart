class InvoiceItemModel {
  final int id;
  final int invoiceId;
  final String feeType; 
  final double amount;
  final double paidAmount;
  final double remainingAmount;

  InvoiceItemModel({
    required this.id,
    required this.invoiceId,
    required this.feeType,
    required this.amount,
    required this.paidAmount,
    required this.remainingAmount,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    // Extract name from fee_type object
    String type = 'General';
    if (json['fee_type'] is Map) {
      type = json['fee_type']['name'] ?? 'General';
    } else if (json['fee_type'] is String) {
      type = json['fee_type'];
    }

    // Match names with the actual JSON from the server
    double amt = double.tryParse(json['total_price']?.toString() ?? '0') ?? 0;
    double paid = double.tryParse(json['amount_paid']?.toString() ?? '0') ?? 0;
    
    return InvoiceItemModel(
      id: json['id'] ?? 0,
      invoiceId: json['invoice_id'] ?? 0,
      feeType: type,
      amount: amt,
      paidAmount: paid,
      remainingAmount: amt - paid,
    );
  }
}
