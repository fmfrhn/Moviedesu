import 'package:dio/dio.dart';

final Dio dio = Dio(BaseOptions(
  baseUrl: "http://192.168.227.221:8000/api/",
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 3)));

class ApiClient {
  Future<Response> get(String path) async {
    try {
      final response = await dio.get(Uri.encodeFull(path));
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      final response = await dio.post(Uri.encodeFull(path), data: data);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Response> put(String path, dynamic data) async {
    try {
      final response = await dio.put(Uri.encodeFull(path), data: data);
      return response;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      final response = await dio.delete(Uri.encodeFull(path));
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}
