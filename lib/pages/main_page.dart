import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../services/tmdb_service.dart';
import '../widgets/movie_card.dart';

class MainPage extends StatelessWidget {
  final String username;

  const MainPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usamos ChangeNotifierProvider para fornecer a instância do MovieProvider ao widget MainPage
    return ChangeNotifierProvider(
      create: (_) => MovieProvider(TmdbService())..fetchPopularMovies(),
      child: Scaffold(
        backgroundColor: Colors.black,
        // Configuração do AppBar com o título e ícones de navegação
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false, // Remove o botão de voltar padrão
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
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
            ],
          ),
          actions: [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                        'Olá, $username',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Aproveite os melhores filmes e séries.',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Pesquise aqui',
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Filmes Populares',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                // Usamos o Consumer<MovieProvider> para construir uma lista horizontal de filmes populares.
                // Carrega as imagens e títulos dos filmes.
                child: Consumer<MovieProvider>(
                  builder: (context, movieProvider, child) {
                    if (movieProvider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (movieProvider.movies.isEmpty) {
                      return Center(
                        child: Text(
                          'Nenhum filme encontrado.',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieProvider.movies.length,
                      itemBuilder: (context, index) {
                        final movie = movieProvider.movies[index];
                        final posterUrl = 'https://image.tmdb.org/t/p/w200${movie['poster_path']}';
                        final releaseDate = movie['release_date'] != null ? movie['release_date'].split('-')[0] : 'Desconhecido';
                        return MovieCard(
                          title: movie['title'],
                          posterUrl: posterUrl,
                          releaseDate: releaseDate,
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Categorias',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Consumer<MovieProvider>(
                  builder: (context, movieProvider, child) {
                    if (movieProvider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (movieProvider.movies.isEmpty) {
                      return Center(
                        child: Text(
                          'Nenhum filme encontrado.',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieProvider.movies.length,
                      itemBuilder: (context, index) {
                        final movie = movieProvider.movies[index];
                        final posterUrl = 'https://image.tmdb.org/t/p/w200${movie['poster_path']}';
                        final releaseDate = movie['release_date'] != null ? movie['release_date'].split('-')[0] : 'Desconhecido';
                        return MovieCard(
                          title: movie['title'],
                          posterUrl: posterUrl,
                          releaseDate: releaseDate,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
