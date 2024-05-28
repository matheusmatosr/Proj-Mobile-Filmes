import 'dart:convert';
import 'package:http/http.dart' as http;

class ImdbService {
  final String apiKey = 'CHAVE_DE_API';

// Exemplo para chamada na tela principal de filmes populares

  Future<List<dynamic>> fetchPopularMovies() async {
    final String url = 'https://imdb-api.com/en/API/MostPopularMovies/$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'];
    } else {
      throw Exception('Failed to load popular movies');
    }
  }
}
