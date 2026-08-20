import '../../core/AppConstants.dart';

class Profilemodel {
  final int? id;
  final String full_name;
  final String email;
  final String phone;
  final String location;
  final String? profile_image;

  Profilemodel({
    this.id,
    required this.full_name,
    required this.email,
    required this.phone,
    required this.location,
    this.profile_image,
  });

  factory Profilemodel.fromJson(Map<String, dynamic> json) {

    late Map<String, dynamic> map;

    print("fromJson keys: ${json.keys.toList()}");

    if (json.containsKey('profile')) {
      final profile = (json['profile'] as Map).cast<String, dynamic>();
      final original = (profile['original'] as Map).cast<String, dynamic>();
      map = (original['user'] as Map).cast<String, dynamic>();

    } else if (json.containsKey('user')) {
      map = (json['user'] as Map).cast<String, dynamic>();
    } else {
      map = json;
    }

    String? imageUrl = map['profile_image'];
    if (imageUrl != null) {
      imageUrl = imageUrl.replaceAll('http://localhost', AppConstants.linkServerName);
    }
    return Profilemodel(
      id: map['id'] is int ? map['id'] :int.tryParse(map['id']?.toString() ?? ''),
      full_name: map['full_name'] ?? 'Unknown',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      profile_image: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': full_name,
      'email': email,
      'phone': phone,
      'location': location,
      'profile_image': profile_image,
    };
  }

  Profilemodel copyWith({
    int? id,
    String? full_name,
    String? email,
    String? phone,
    String? location,
    String? profile_image,
}){
    return Profilemodel(
      id: id ?? this.id,
      full_name: full_name ?? this.full_name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      profile_image: profile_image ?? this.profile_image,
    );
}
}