class Movies {
  final String title;
  final String imdbid;
  final String poster;

  Movies({
    this.title = '',
    this.imdbid = '',
    this.poster = ''
  });

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
      title: json['Title'] ?? 'Unknown Title',
      imdbid: json['imdbID'] ?? '',
      poster: json['Poster'] ?? 'https://via.placeholder.com/150', // Placeholder jika poster tidak tersedia
    );
  }
}

class Search {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;

  Search({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.type,
    required this.poster,
  });

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      title: json['Title'] ?? 'No Title',
      year: json['Year'] ?? 'Unknown Year',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? 'Unknown',
      poster: json['Poster'] ?? 'N/A',
    );
  }
}