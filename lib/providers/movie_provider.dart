// Um provedor de estado para gerenciar as chamadas à API e o estado dos filmes
import 'package:flutter/material.dart';
import '../services/tmdb_service.dart';

class MovieProvider extends ChangeNotifier {
  final TmdbService tmdbService;
  bool isLoading = false;
  List<dynamic> popularMovies = [];
  List<dynamic> featuredMovies = [];
  List<dynamic> topRatedMovies = [];
  List<dynamic> upcomingMovies = [];
  List<dynamic> popularSeries = [];
  List<dynamic> topRatedSeries = [];
  List<dynamic> onAirSeries = [];

  MovieProvider(this.tmdbService);

  Future<void> fetchPopularMovies() async {
    isLoading = true;
    notifyListeners();
    popularMovies = await tmdbService.getPopularMovies();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFeaturedMovies() async {
    isLoading = true;
    notifyListeners();
    featuredMovies = await tmdbService.getFeaturedMovies();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTopRatedMovies() async {
    isLoading = true;
    notifyListeners();
    topRatedMovies = await tmdbService.getTopRatedMovies();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUpcomingMovies() async {
    isLoading = true;
    notifyListeners();
    upcomingMovies = await tmdbService.getUpcomingMovies();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPopularSeries() async {
    isLoading = true;
    notifyListeners();
    popularSeries = await tmdbService.getPopularSeries();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTopRatedSeries() async {
    isLoading = true;
    notifyListeners();
    topRatedSeries = await tmdbService.getTopRatedSeries();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchOnAirSeries() async {
    isLoading = true;
    notifyListeners();
    onAirSeries = await tmdbService.getOnAirSeries();
    isLoading = false;
    notifyListeners();
  }
}
