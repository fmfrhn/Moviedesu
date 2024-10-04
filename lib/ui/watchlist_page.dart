import 'package:flutter/material.dart';
import 'package:moviedesu/model/watchlist.dart';
import 'package:moviedesu/service/movies_service.dart';
import 'package:moviedesu/ui/detail_movie.dart';
import 'package:moviedesu/widget/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  int? userId;
  String _errorMessage = '';
  bool _isLoading = false;
  final MoviesService _moviesService = MoviesService();
  List<Watchlist> _movies = [];

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
      print("User ID yang diambil di getUserId: $userId");
    });
    if (userId != null) {
      _showMovies(); // Panggil _showMovies setelah userId berhasil diambil
    }
  }

  void _showMovies() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Watchlist> movies = await _moviesService.getWatchlist(userId!);
      setState(() {
        _movies = movies;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load Watchlist. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text("My Watchlist"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : _errorMessage.isNotEmpty
                    ? Text(_errorMessage, style: TextStyle(color: Colors.red))
                    : Expanded(
                        child: _movies.isNotEmpty
                            ? ListView.builder(
                                itemCount: _movies.length,
                                itemBuilder: (context, index) {
                                  final movie = _movies[index];
                                  return Card(
                                    child: ListTile(
                                      leading: movie.poster != 'N/A'
                                          ? Image.network(
                                              movie.poster,
                                              width: 50,
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(Icons
                                              .image_not_supported), // Placeholder jika poster tidak tersedia
                                      title: Text(movie.title),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailMovie(
                                                imdbID: movie.imdbid),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              )
                            : const Text('No movies found'),
                      ),
          ],
        ),
      ),
    );
  }
}
