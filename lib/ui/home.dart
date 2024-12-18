import 'package:flutter/material.dart';
import 'package:moviedesu/model/movies.dart';
import 'package:moviedesu/service/movies_service.dart';
import 'package:moviedesu/ui/detail_movie.dart';
import 'package:moviedesu/widget/sidebar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MoviesService _MoviesService = MoviesService();
  final TextEditingController _searchController = TextEditingController();
  List<Movies> _movies = [];
  String _errorMessage = '';
  bool _isLoading = false;

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
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text(
          'Movie Search',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField untuk memasukkan judul film yang akan dicari
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter Movie Title',
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.deepPurple),
                  onPressed: _searchMovies,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : _errorMessage.isNotEmpty
                    ? Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      )
                    : Expanded(
                        child: _movies.isNotEmpty
                            ? GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Jumlah kolom
                                  crossAxisSpacing:
                                      16, // Jarak horizontal antar card
                                  mainAxisSpacing:
                                      16, // Jarak vertikal antar card
                                  childAspectRatio:
                                      0.7, // Rasio aspek card (width / height)
                                ),
                                itemCount: _movies.length,
                                itemBuilder: (context, index) {
                                  final movie = _movies[index];
                                  return FadeIn(
                                    duration: const Duration(milliseconds: 300),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      elevation: 3,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailMovie(
                                                  imdbID: movie.imdbid ?? ''),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Poster film
                                            movie.poster != null &&
                                                    movie.poster != 'N/A'
                                                ? ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius
                                                            .vertical(
                                                      top:
                                                          Radius.circular(12.0),
                                                    ),
                                                    child: Image.network(
                                                      movie.poster ?? '',
                                                      width: double.infinity,
                                                      height: 150,
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Judul film
                                                  Text(
                                                    movie.title ??
                                                        'No title available',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  // Tahun rilis film
                                                  Text(
                                                    'Release: ${movie.year ?? 'Unknown'}',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Text(
                                'No movies found',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
          ],
        ),
      ),
    );
  }
}

// Widget FadeIn sederhana untuk menambahkan animasi
class FadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const FadeIn(
      {required this.child, this.duration = const Duration(milliseconds: 500)});

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}
