class SupervisorModel{

 final int supervisor_id;
 final int id;
  final String full_name;
  final String email;
  final String phone;
  final String location;
   int status;
 final String? profile_image;


 SupervisorModel({
   required this.supervisor_id,
   required this.id,
   required this.full_name,
   required this.email,
   required this.phone,
   required this.location,
   required this.status,
   this.profile_image,
 });
  factory SupervisorModel.fromJson(Map<String, dynamic> json) {
    return SupervisorModel(
      supervisor_id: json['id']??0,
      id: json['user']['id']??0,
      full_name: json['user']['full_name']??'',
      email: json['user']['email']??'',
      phone: json['user']['phone']??'',
      location: json['user']['location']??'',
      profile_image: json['user']['profile_image']??'',
      status: json['user']['approved'] is int ? json['user']['approved']??0 : (int.tryParse(json['user']['approved'].toString()) ?? 0),
    );
  }
}