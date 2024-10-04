import 'package:flutter/material.dart';
import 'package:moviedesu/service/movies_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class DetailMovie extends StatefulWidget {
  final String imdbID;

  DetailMovie({required this.imdbID});

  @override
  _DetailMovieState createState() => _DetailMovieState();
}

class _DetailMovieState extends State<DetailMovie> {
  Map<String, dynamic>? movieDetail;
  int? userId; // Variabel untuk menyimpan userId dari SharedPreferences

  @override
  void initState() {
    super.initState();
    _fetchMovieDetail();
    _getUserId(); // Ambil userId dari SharedPreferences
  }

  void _fetchMovieDetail() async {
    Map<String, dynamic>? result =
        await MoviesService().fetchMovieDetail(widget.imdbID);
    setState(() {
      movieDetail = result;
    });
  }

  // Ambil userId dari SharedPreferences
  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
      print("User ID yang diambil di getUserId: $userId");
    });
  }

  void _addToWatchlist() async {
    if (userId != null && movieDetail != null) {
      // Gunakan MoviesService untuk menambah film ke watchlist
      await MoviesService().addToWatchlist(
        userId: userId!,
        imdbID: movieDetail!['imdbID'],
        title: movieDetail!['Title'],
        poster: movieDetail!['Poster'],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Movie added to Watchlist")),
      );
      print("User ID yang diambil di addToWatchList: $userId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Detail'),
      ),
      body: movieDetail != null
          ? SingleChildScrollView(
              // Bungkus dengan SingleChildScrollView untuk scroll vertikal
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movieDetail!['Title'] ?? 'No Title',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    movieDetail!['Poster'] != "N/A"
                        ? Image.network(movieDetail!['Poster'])
                        : Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey,
                            child: Icon(Icons.movie, size: 100),
                          ),
                    SizedBox(height: 20),
                    Text(
                      'Year: ${movieDetail!['Year'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Genre: ${movieDetail!['Genre'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Plot: ${movieDetail!['Plot'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addToWatchlist,
                      child: Text("Add to Watchlist"),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
