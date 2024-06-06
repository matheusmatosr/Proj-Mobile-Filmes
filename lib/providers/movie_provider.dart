// Um provedor de estado para gerenciar as chamadas à API e o estado dos filmes
import 'package:flutter/material.dart';
import '../services/tmdb_service.dart';

class MovieProvider with ChangeNotifier {
  final TmdbService _tmdbService;
  List<dynamic> _movies = [];
  bool _isLoading = false;

  MovieProvider(this._tmdbService);

  List<dynamic> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> fetchPopularMovies() async {
    _isLoading = true;
    notifyListeners();
    try {
      _movies = await _tmdbService.fetchPopularMovies();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
