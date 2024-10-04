class User {
  String? name;
  String? password;
  String? email;

  User({
    this.name,
    this.password,
    this.email
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      password: json['password'],
      email: json['email']
    );
  }

  // Method to convert Poli object into JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
      'email': email
    };
  }
}