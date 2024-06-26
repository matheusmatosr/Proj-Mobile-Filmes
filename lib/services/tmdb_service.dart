import 'dart:convert';
import 'package:http/http.dart' as http;

class TmdbService {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = '61944e64794674cad7a92649ab1a63d5';

  Future<List<dynamic>> getPopularMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=pt-BR'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<dynamic>> getFeaturedMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/top_rated?api_key=$_apiKey&language=pt-BR'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load featured movies');
    }
  }

  Future<List<dynamic>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/top_rated?api_key=$_apiKey&language=pt-BR'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<List<dynamic>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/upcoming?api_key=$_apiKey&language=pt-BR'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<dynamic>> getPopularSeries() async {
    final response = await http.get(Uri.parse('$_baseUrl/tv/popular?api_key=$_apiKey&language=pt-BR'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load popular series');
    }
  }

  Future<List<dynamic>> getTopRatedSeries() async {
    final response = await http.get(Uri.parse('$_baseUrl/tv/top_rated?api_key=$_apiKey&language=pt-BR'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load top rated series');
    }
  }

  Future<List<dynamic>> getOnAirSeries() async {
    final response = await http.get(Uri.parse('$_baseUrl/tv/on_the_air?api_key=$_apiKey&language=pt-BR'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load on air series');
    }
  }

  Future<List<dynamic>> searchMoviesAndSeries(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search/multi?api_key=$_apiKey&language=pt-BR&query=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to search movies and series');
    }
  }

   Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
  final response = await http.get(Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey&language=pt-BR&append_to_response=release_dates,credits'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load movie details');
  }
}


  Future<String?> getMovieTrailer(int movieId) async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/$movieId/videos?api_key=$_apiKey&language=pt-BR'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        return 'https://www.youtube.com/watch?v=${data['results'][0]['key']}';
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load movie trailer');
    }
  }

  Future<Map<String, dynamic>> getMovieCredits(int movieId) async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/$movieId/credits?api_key=$_apiKey&language=pt-BR'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data; // return the full data map
    } else {
      throw Exception('Failed to load movie credits');
    }
  }

}
