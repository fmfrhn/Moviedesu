class Watchlist {
  final String title;
  final String imdbid;
  final String poster;

  Watchlist({
    this.title = '',
    this.imdbid = '',
    this.poster = ''
  });

  factory Watchlist.fromJson(Map<String, dynamic> json) {
    return Watchlist(
      title: json['title'] ?? 'Unknown Title',
      imdbid: json['imdb_id'] ?? '',
      poster: json['poster'] ?? 'https://via.placeholder.com/150', // Placeholder jika poster tidak tersedia
    );
  }
}