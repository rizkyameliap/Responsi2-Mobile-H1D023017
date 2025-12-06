class User {
  final int id;
  final String nama;
  final String email;
  final String? token;

  User({
    required this.id,
    required this.nama,
    required this.email,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'token': token,
    };
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String nama;
  final String email;
  final String password;

  RegisterRequest({
    required this.nama,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'password': password,
    };
  }
}

class AuthResponse {
  final String message;
  final User user;
  final String token;

  AuthResponse({
    required this.message,
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] ?? '',
      user: User.fromJson(json['data']['user']),
      token: json['data']['token'] ?? '',
    );
  }
}