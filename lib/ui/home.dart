import 'package:flutter/material.dart';
import 'package:moviedesu/model/movies.dart';
import 'package:moviedesu/service/movies_service.dart';
import 'package:moviedesu/ui/detail_movie.dart';
import 'package:moviedesu/widget/sidebar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MoviesService _MoviesService = MoviesService();
  final TextEditingController _searchController =
      TextEditingController(); // TextField Controller
  List<Movies> _movies = []; // List untuk menyimpan hasil pencarian film
  String _errorMessage = ''; // Variabel untuk menyimpan pesan error
  bool _isLoading = false; // Menandakan jika pencarian sedang berlangsung

  // Method untuk mengambil data film berdasarkan judul yang dimasukkan
  void _searchMovies() async {
    String query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a movie title';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      List<Movies> movies = await _MoviesService.fetchMovies(query);
      setState(() {
        _movies = movies;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to fetch movies. Please try again.';
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
        title: const Text('Movie Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField untuk memasukkan judul film yang akan dicari
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter Movie Title',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchMovies, // Panggil method pencarian
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator() // Tampilkan loading jika pencarian sedang berlangsung
                : _errorMessage.isNotEmpty
                    ? Text(_errorMessage,
                        style: TextStyle(
                            color: Colors.red)) // Tampilkan error jika ada
                    : Expanded(
                        // Tampilkan hasil pencarian jika ada
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
