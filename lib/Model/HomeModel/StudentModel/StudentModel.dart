class StudentModel{
  final int student_id;
  final String student_number;
  final int id;
  final String full_name;
  final String email;
  final String phone;
  final String location;
  final String? profile_image;
   int status;

  StudentModel({required this.student_id,required this.student_number,required this.id,required this.full_name,required this.email,required this.phone,required this.location,required this.status,this.profile_image});

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      student_id: json['student_id']?? 0,
      student_number:json['student_number']??"",
      id: json['user']['id']?? 0,
      full_name:  json['user']['full_name']??"",
      email:  json['user']['email']??"",
      phone:  json['user']['phone']??"",
      location:  json['user']['location']??"",
      status:  json['user']['approved']?? 0,
        profile_image:json['user']['profile_image']??"",
    );
  }
}
