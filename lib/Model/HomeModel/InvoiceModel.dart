class InvoiceModel {
  final String id;
  final String full_name;
  final String email;
  final String phone;
  final String total_paid;
  final String total_amount;
   String status;
  final String? personalImage;
  final String location;

  InvoiceModel({
    required this.id,
    required this.full_name,
    required this.email,
    required this.phone,
    required this.total_paid,
    required this.total_amount,
    required this.status,
    required this.location,
    this.personalImage,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {

    final student=json['student'];
    final user=student!=null?student['user']:null;


    return InvoiceModel(
      id: json['id']?.toString() ?? '',
      full_name: user?['full_name'] ?? 'Unknown',
      email: user?['email'] ?? 'No Email',
      phone: user?['phone'] ?? 'No Phone',
      total_paid: json['total_paid']?.toString() ?? '0.00',
      total_amount: json['total_amount']?.toString() ?? '0.00',
      status: json['status'] ?? "unpaid",
      location: user?['location'],
      personalImage: user?['personal_image'],
    );
  }
}