import 'package:flutter/material.dart';
import 'package:moviedesu/service/movies_service.dart';
import 'package:moviedesu/widget/rating_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailMovie extends StatefulWidget {
  final String imdbID;

  DetailMovie({required this.imdbID});

  @override
  _DetailMovieState createState() => _DetailMovieState();
}

class _DetailMovieState extends State<DetailMovie> {
  Map<String, dynamic>? movieDetail;
  int? userId;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Global key untuk Scaffold

  @override
  void initState() {
    super.initState();
    _fetchMovieDetail();
    _getUserId();
  }

  void _fetchMovieDetail() async {
    Map<String, dynamic>? result =
        await MoviesService().fetchMovieDetail(widget.imdbID);
    setState(() {
      movieDetail = result;
    });
  }

  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  void _addToWatchlist() async {
    if (userId != null && movieDetail != null) {
      await MoviesService().addToWatchlist(
        userId: userId!,
        imdbID: movieDetail!['imdbID'],
        title: movieDetail!['Title'],
        poster: movieDetail!['Poster'],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Movie added to Watchlist")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Menetapkan key di Scaffold
      appBar: AppBar(
        title: const Text('Movie Detail'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: movieDetail != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: movieDetail!['Poster'] != "N/A"
                            ? Image.network(
                                movieDetail!['Poster'],
                                height: 300,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 200,
                                width: 150,
                                color: Colors.grey,
                                child: const Icon(Icons.movie, size: 80),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        movieDetail!['Title'] ?? 'No Title',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        '(${movieDetail!['Released'] ?? 'N/A'})',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // IMDb Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        const SizedBox(width: 8),
                        Text(
                          'IMDb Rating: ${movieDetail!['imdbRating'] ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // IMDb Votes
                    Row(
                      children: [
                        const Icon(Icons.thumb_up, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'IMDb Votes: ${movieDetail!['imdbVotes'] ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Box Office
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Box Office: ${movieDetail!['BoxOffice'] ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Genre: ${movieDetail!['Genre'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Plot:',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              movieDetail!['Plot'] ??
                                  'No description available.',
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Director: ${movieDetail!['Director'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Actors: ${movieDetail!['Actors'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Runtime: ${movieDetail!['Runtime'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Language: ${movieDetail!['Language'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Country: ${movieDetail!['Country'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Awards: ${movieDetail!['Awards'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _addToWatchlist,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text("Add to Watchlist"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .white, // Use backgroundColor instead of primary
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 16), // Add some space between the buttons
                          ElevatedButton(
                            onPressed: () {
                              // Tampilkan drawer dengan menggunakan key
                              _scaffoldKey.currentState?.openEndDrawer();
                            },
                            child: const Text('Rate & Comment'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .greenAccent, // Choose any color you like
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      // Menggunakan RatingDrawer dari rating_drawer.dart
      endDrawer: const RatingDrawer(),
    );
  }
}
