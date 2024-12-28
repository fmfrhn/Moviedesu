import 'package:flutter/material.dart';
import 'package:moviedesu/model/watchlist.dart';
import 'package:moviedesu/service/movies_service.dart';
import 'package:moviedesu/ui/detail_movie.dart';
import 'package:moviedesu/widget/sidebar.dart';
import 'package:moviedesu/widget/app_bar.dart';
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
    });
    if (userId != null) {
      _showMovies(); // Call _showMovies once userId is retrieved
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

  Future<void> _deleteWatchlist(String imdb_id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _moviesService.deleteWatchlist(imdb_id: imdb_id);
      _showMovies(); // Reload list after deletion
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to delete movie. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDeleteConfirmationDialog(String imdbID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text(
              "Are you sure you want to delete this movie from your watchlist?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog before deletion
                _deleteWatchlist(imdbID); // Delete item from watchlist
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Add title text here
            const Text(
              "Watchlist Page",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Expanded(
                        child: _movies.isNotEmpty
                            ? GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Number of columns
                                  crossAxisSpacing:
                                      16, // Horizontal space between cards
                                  mainAxisSpacing:
                                      16, // Vertical space between cards
                                  childAspectRatio:
                                      0.7, // Aspect ratio of cards (width / height)
                                ),
                                itemCount: _movies.length,
                                itemBuilder: (context, index) {
                                  final movie = _movies[index];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    elevation: 3,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailMovie(
                                                imdbID: movie.imdbid),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Movie Poster
                                          movie.poster != 'N/A'
                                              ? ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                          top: Radius.circular(
                                                              12.0)),
                                                  child: Image.network(
                                                    movie.poster,
                                                    width: double.infinity,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Container(
                                                  width: double.infinity,
                                                  height: 150,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.image_not_supported,
                                                    size: 50,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Movie Title
                                                Text(
                                                  movie.title,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                // Movie Year
                                                Text(
                                                  'IMDB ID: ${movie.imdbid}',
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                _showDeleteConfirmationDialog(
                                                    movie.imdbid);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Center(child: Text('No movies found'))),
          ],
        ),
      ),
    );
  }
}
