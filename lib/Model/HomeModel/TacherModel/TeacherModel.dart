class TeacherModel{
  final int id;
  final String full_name;
  final String email;
  final String phone;
  final String location;
  final String profile_image;
   int status;
  final int teacher_id;
  final int salary;
  TeacherModel({required this.id,required this.full_name,required this.email,required this.phone,required this.location,required this.profile_image,required this.status,required this.teacher_id,required this.salary});

 factory TeacherModel.fromJson(Map<String,dynamic> json){
    return TeacherModel(
        id: json['user']['id']??0,
        full_name: json['user']['full_name']??'',
        email: json['user']['email']??'',
        phone: json['user']['phone']??'',
        location: json['user']['location']??'',
        profile_image: json['user']['profile_image']??'',
        status: json['user']['approved']??0,
        teacher_id: json['teacher_id']??0,
        salary: json['salary']??0,
    );
  }
}