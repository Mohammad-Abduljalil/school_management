class SignInModel{
  final String email;
  final String password;
  final String? token;

  SignInModel({required this.email,required this.password,this.token});

  factory SignInModel.fromJson(Map<String ,dynamic>json){
    return SignInModel(email: json['email'],
        password: '',
        token: json['token']//or access_token
    );
  }

  Map<String , dynamic> toJson(){
    return {
      'email':email,
      'password':password,
    };
  }
}