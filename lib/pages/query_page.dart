import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

class QueryPage extends StatelessWidget {
  const QueryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Pesquisar Filmes e Séries',
          style: TextStyle(
              color: Colors.white), // Altera a cor do título para branco
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onFieldSubmitted: (value) {
                Provider.of<MovieProvider>(context, listen: false)
                    .searchMoviesAndSeries(value);
              },
              decoration: InputDecoration(
                hintText: 'Digite aqui para pesquisar...',
                hintStyle: TextStyle(color: Colors.grey[700]),
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Consumer<MovieProvider>(
              builder: (context, movieProvider, child) {
                if (movieProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                final searchResults = movieProvider.searchResults;
                if (searchResults.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhum resultado encontrado.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20, // Aumenta o espaço entre as linhas
                      childAspectRatio: 0.6,
                    ),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final item = searchResults[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom:
                                20), // Adiciona espaço na parte inferior do card
                        child: _buildMovieCard(item),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard(Map<String, dynamic> item) {
    if (item['media_type'] == 'movie') {
      return MovieCard(
        title: item['title'],
        posterUrl: 'https://image.tmdb.org/t/p/w200${item['poster_path']}',
        releaseDate: item['release_date'] != null
            ? item['release_date'].split('-')[0]
            : 'Desconhecido',
      );
    } else if (item['media_type'] == 'tv') {
      return MovieCard(
        title: item['name'],
        posterUrl: 'https://image.tmdb.org/t/p/w200${item['poster_path']}',
        releaseDate: item['first_air_date'] != null
            ? item['first_air_date'].split('-')[0]
            : 'Desconhecido',
      );
    }
    return SizedBox.shrink();
  }
}
