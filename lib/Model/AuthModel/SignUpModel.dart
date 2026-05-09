class SignUpModel{
  final String fullName;
  final String email;
  final String phoneNumber;
  final  String location;
  final  String password;
  final  String passwordConfirm;
  final String?  personalImage;
  final String? token;

  SignUpModel({required this.fullName,required this.email,required this.phoneNumber,required this.location,required this.password,required this.passwordConfirm,this.personalImage,this.token});

  Map<String,dynamic> toJson(){
    return {
      'fullName':fullName,
      'email':email,
      'phoneNumber':phoneNumber,
      'location':location,
      'password':password,
      'passwordConfirm':passwordConfirm,
    };
  }

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      location: json['location'] ?? '',
      password: '',
      passwordConfirm: '',
      personalImage: json['personal_image'],
      token: json['token'],
    );
  }
}