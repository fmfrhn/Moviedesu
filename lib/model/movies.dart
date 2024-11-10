class Movies {
  final String title;
  final String imdbid;
  final String poster;
  final String year;

  Movies({
    this.title = '',
    this.imdbid = '',
    this.poster = '',
    this.year = ''
  });

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
      title: json['Title'] ?? 'Unknown Title',
      imdbid: json['imdbID'] ?? '',
      year: json['Year'] ?? '',
      poster: json['Poster'] ?? 'https://via.placeholder.com/150', // Placeholder jika poster tidak tersedia
    );
  }
}

class Search {
  final String title;
  final String released;
  final String imdbID;
  final String type;
  final String poster;
  final String imdbRating;  // IMDb Rating
  final String imdbVotes;   // IMDb Votes
  final String boxOffice;   // Box Office
  final String director;    // Director
  final String actors;      // Actors
  final String runtime;     // Runtime
  final String language;    // Language
  final String country;     // Country
  final String awards;      // Awards

  Search({
    required this.title,
    required this.released,
    required this.imdbID,
    required this.type,
    required this.poster,
    required this.imdbRating,
    required this.imdbVotes,
    required this.boxOffice,
    required this.director,
    required this.actors,
    required this.runtime,
    required this.language,
    required this.country,
    required this.awards,
  });

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      title: json['Title'] ?? 'No Title',
      released: json['Released'] ?? 'Unknown Released',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? 'Unknown',
      poster: json['Poster'] ?? 'N/A',
      imdbRating: json['imdbRating'] ?? 'N/A',
      imdbVotes: json['imdbVotes'] ?? 'N/A',
      boxOffice: json['BoxOffice'] ?? 'N/A',
      director: json['Director'] ?? 'N/A',
      actors: json['Actors'] ?? 'N/A',
      runtime: json['Runtime'] ?? 'N/A',
      language: json['Language'] ?? 'N/A',
      country: json['Country'] ?? 'N/A',
      awards: json['Awards'] ?? 'N/A',
    );
  }
}
