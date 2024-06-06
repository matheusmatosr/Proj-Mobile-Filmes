import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../services/tmdb_service.dart';
import '../widgets/movie_card.dart';
import 'query_page.dart'; // Importa a página de busca

class MainPage extends StatelessWidget {
  final String username;

  const MainPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieProvider(TmdbService())
        ..fetchPopularMovies()
        ..fetchFeaturedMovies()
        ..fetchTopRatedMovies()
        ..fetchUpcomingMovies()
        ..fetchPopularSeries()
        ..fetchTopRatedSeries()
        ..fetchOnAirSeries(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Cine',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'UCL+',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: Icon(Icons.exit_to_app),
              tooltip: 'Sair',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, $username!',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Aproveite os melhores filmes e séries',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QueryPage()),
                  );
                },
                child: TextFormField(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QueryPage()),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Palavra-chave, título, ano...',
                    hintStyle: TextStyle(color: Colors.grey[700]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    _buildSectionTitle('Filmes Populares'),
                    SizedBox(height: 10),
                    _buildMovieList(context, 'popularMovies'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Filmes em destaque'),
                    SizedBox(height: 10),
                    _buildMovieList(context, 'featuredMovies'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Mais bem avaliados'),
                    SizedBox(height: 10),
                    _buildMovieList(context, 'topRatedMovies'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Lançamentos'),
                    SizedBox(height: 10),
                    _buildMovieList(context, 'upcomingMovies'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Séries de TV Populares'),
                    SizedBox(height: 10),
                    _buildSeriesList(context, 'popularSeries'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Séries de TV Mais Bem Avaliadas'),
                    SizedBox(height: 10),
                    _buildSeriesList(context, 'topRatedSeries'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Séries de TV no Ar Atualmente'),
                    SizedBox(height: 10),
                    _buildSeriesList(context, 'onAirSeries'),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.red),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Colors.red),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.red),
              label: '',
            ),
          ],
          currentIndex: 0,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {},
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMovieList(BuildContext context, String listName) {
    return SizedBox(
      height: 220, // Aumenta a altura para aumentar o espaço
      child: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          final movies = _getMovieList(movieProvider, listName);
          if (movies.isEmpty) {
            return Center(
              child: Text(
                'Nenhum filme encontrado.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              final posterUrl = 'https://image.tmdb.org/t/p/w200${movie['poster_path']}';
              final releaseDate = movie['release_date'] != null ? movie['release_date'].split('-')[0] : 'Desconhecido';
              return Padding(
                padding: EdgeInsets.only(right: 10),
                child: MovieCard(
                  title: movie['title'],
                  posterUrl: posterUrl,
                  releaseDate: releaseDate,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSeriesList(BuildContext context, String listName) {
    return SizedBox(
      height: 220, // Aumenta a altura para aumentar o espaço
      child: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          final series = _getSeriesList(movieProvider, listName);
          if (series.isEmpty) {
            return Center(
              child: Text(
                'Nenhuma série encontrada.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: series.length,
            itemBuilder: (context, index) {
              final serie = series[index];
              final posterUrl = 'https://image.tmdb.org/t/p/w200${serie['poster_path']}';
              final releaseDate = serie['first_air_date'] != null ? serie['first_air_date'].split('-')[0] : 'Desconhecido';
              return Padding(
                padding: EdgeInsets.only(right: 10),
                child: MovieCard(
                  title: serie['name'],
                  posterUrl: posterUrl,
                  releaseDate: releaseDate,
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<dynamic> _getMovieList(MovieProvider movieProvider, String listName) {
    switch (listName) {
      case 'popularMovies':
        return movieProvider.popularMovies;
      case 'featuredMovies':
        return movieProvider.featuredMovies;
      case 'topRatedMovies':
        return movieProvider.topRatedMovies;
      case 'upcomingMovies':
        return movieProvider.upcomingMovies;
      default:
        return [];
    }
  }

  List<dynamic> _getSeriesList(MovieProvider movieProvider, String listName) {
    switch (listName) {
      case 'popularSeries':
        return movieProvider.popularSeries;
      case 'topRatedSeries':
        return movieProvider.topRatedSeries;
      case 'onAirSeries':
        return movieProvider.onAirSeries;
      default:
        return [];
    }
  }
}
