class UserModel {
  final int? id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String location;
  final String? personalImage;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.location,
    this.personalImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] :int.tryParse(json['id']?.toString() ?? ''),
      fullName: json['full_name'] ?? 'Unknown',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      location: json['location'] ?? '',
      personalImage: json['personal_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'location': location,
      'personal_image': personalImage,
    };
  }

  UserModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? location,
    String? personalImage,
}){
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      personalImage: personalImage ?? this.personalImage,
    );
}
}