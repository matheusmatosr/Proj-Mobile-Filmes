import 'dart:convert';
import 'package:http/http.dart' as http;

class TmdbService {
  final String apiKey = '61944e64794674cad7a92649ab1a63d5';

  Future<List<dynamic>> fetchPopularMovies() async {
    final String url = 'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=pt-BR';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load popular movies');
    }
  }
}
