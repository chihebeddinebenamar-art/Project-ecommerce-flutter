class UserProfile {
  final String uid;
  String name;
  String email;
  String? phone;
  String? address;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.address,
  });

  factory UserProfile.fromFirebaseUser(String uid, String email, {String? name, String? phone, String? address}) {
    return UserProfile(
      uid: uid,
      name: name ?? email.split('@')[0],
      email: email,
      phone: phone,
      address: address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
    );
  }
}

