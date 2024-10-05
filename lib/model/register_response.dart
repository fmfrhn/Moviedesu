class RegisterResponse {
  final bool status;
  final String message;
  // final String token;

  RegisterResponse({
    this.status = false,
    this.message = '',
    // this.token = ''
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      status: json['status'],
      message: json['message'],
      // token: json['token']
    );
  }
}