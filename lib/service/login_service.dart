import 'package:dio/dio.dart';
import 'package:moviedesu/model/login_response.dart';
import 'package:moviedesu/model/register_response.dart';
// import 'package:moviedesu/model/user.dart';

import '../helpers/api_client.dart';

class LoginService {
  Future<LoginResponse> login(String textEmail, String textPassword) async {
    try {
      final Response response = await ApiClient()
          .post('login', {'email': textEmail, 'password': textPassword});
      LoginResponse result = LoginResponse.fromJson(response.data);
      return result;
    } on DioException catch (e) {
      print(e);
      return LoginResponse.fromJson(e.response?.data);
    }
  }

  Future<RegisterResponse> register(
      String textEmail, String textName, String textPassword) async {
    final Response response = await ApiClient().post('register',
        {'email': textEmail, 'name': textName, 'password': textPassword});
    RegisterResponse result = RegisterResponse.fromJson(response.data);
    return result;
  }
}
