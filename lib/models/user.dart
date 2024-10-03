class User {
  final String id;
  final String email;
  String? faceId;

  User({required this.id, required this.email, this.faceId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      faceId: json['faceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'faceId': faceId,
    };
  }
}