import 'package:dio/dio.dart';
import 'package:moviedesu/helpers/api_client.dart';
import 'package:moviedesu/model/movies.dart';
import 'package:moviedesu/model/watchlist.dart';

class MoviesService {
  Future<List<Movies>> fetchMovies(String title) async {
    try {
      final Response response = await ApiClient().get("search_movies?s=$title");
      final List data = response.data['data'] as List;
      List<Movies> result = data.map((json) => Movies.fromJson(json)).toList();
      return result;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchMovieDetail(String imdbID) async {
    try {
      final Response response = await ApiClient().get("movies?i=$imdbID");
      final Map<String, dynamic> data =
          response.data['data'] as Map<String, dynamic>;
      return data;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<Watchlist>> getWatchlist(int uid) async {
    try {
      final Response response = await ApiClient().get("show_watchlist?uid=$uid");
      final List data = response.data['data'] as List;
      List<Watchlist> result = data.map((json) => Watchlist.fromJson(json)).toList();
      return result;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<void> addToWatchlist(
      {required int userId,
      required String imdbID,
      required String title,
      required String poster}) async {
        try {
          await ApiClient().post('add_watchlist', {
            'user_id': userId,
            'imdb_id': imdbID,
            'title': title,
            'poster': poster,
          });
        } catch (e) {
          print('Failed to add to watchlist: $e');
        }
  }
}
