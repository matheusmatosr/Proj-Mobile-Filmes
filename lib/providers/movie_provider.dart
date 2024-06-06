import 'package:flutter/foundation.dart';
import '../services/tmdb_service.dart';

class MovieProvider extends ChangeNotifier {
  final TmdbService _tmdbService;
  
  // Lists to hold the data
  List<dynamic> popularMovies = [];
  List<dynamic> featuredMovies = [];
  List<dynamic> topRatedMovies = [];
  List<dynamic> upcomingMovies = [];
  List<dynamic> popularSeries = [];
  List<dynamic> topRatedSeries = [];
  List<dynamic> onAirSeries = [];
  List<dynamic> searchResults = [];

  // State management
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  MovieProvider(this._tmdbService);

  // Fetch functions
  Future<void> fetchPopularMovies() async {
    _isLoading = true;
    popularMovies = await _tmdbService.getPopularMovies();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFeaturedMovies() async {
    _isLoading = true;
    featuredMovies = await _tmdbService.getFeaturedMovies();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTopRatedMovies() async {
    _isLoading = true;
    topRatedMovies = await _tmdbService.getTopRatedMovies();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUpcomingMovies() async {
    _isLoading = true;
    upcomingMovies = await _tmdbService.getUpcomingMovies();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPopularSeries() async {
    _isLoading = true;
    popularSeries = await _tmdbService.getPopularSeries();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTopRatedSeries() async {
    _isLoading = true;
    topRatedSeries = await _tmdbService.getTopRatedSeries();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchOnAirSeries() async {
    _isLoading = true;
    onAirSeries = await _tmdbService.getOnAirSeries();
    _isLoading = false;
    notifyListeners();
  }

  // Search function
  Future<void> searchMoviesAndSeries(String query) async {
    _isLoading = true;
    searchResults = await _tmdbService.searchMoviesAndSeries(query);
    _isLoading = false;
    notifyListeners();
  }
}
