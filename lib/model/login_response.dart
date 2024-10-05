class LoginResponse {
  final bool status;
  final String message;
  final String token;
  final String email;
  final String name;
  final int id;

  LoginResponse({
    this.status = false,
    this.message = '',
    this.token = '',
    this.email = '',
    this.name = '',
    this.id = 3
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      token: json['token'],
      email: json['email'],
      name: json['name'],
      id: json['id']
    );
  }
}