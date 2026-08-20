class SignUpModel{
  final String full_name;
  final String email;
  final String phone;
  final  String location;
  final  String password;
  final  String password_confirmation;
  final String? role;
  final String?  profile_image;
  final String? token;

  SignUpModel({required this.full_name,required this.email,required this.phone,required this.location,required this.password,required this.password_confirmation,required this.role,this.profile_image,this.token});

  Map<String,dynamic> toJson(){
    return {
      'fullName':full_name,
      'email':email,
      'phoneNumber':phone,
      'location':location,
      'password':password,
      'passwordConfirm':password_confirmation,
      'role':role,
    };
  }

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      full_name: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone_number'] ?? '',
      location: json['location'] ?? '',
      password: '',
      password_confirmation: '',
      role: json['role'] ?? 'admin',
      profile_image: json['personal_image'],
      token: json['token'],
    );
  }
}