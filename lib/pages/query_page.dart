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
          style: TextStyle(color: Colors.white),
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
            Expanded(
              child: Consumer<MovieProvider>(
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
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      childAspectRatio: _calculateAspectRatio(context),
                    ),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final item = searchResults[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: MovieCard(
                          title: item['title'] ??
                              item['name'] ??
                              'Título Desconhecido',
                          posterUrl:
                              'https://image.tmdb.org/t/p/w200${item['poster_path']}',
                          releaseDate: _getReleaseDate(item),
                          item: item,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Calcula o número de colunas com base no tamanho da tela
    if (screenWidth < 600) {
      return 0.8; // Para telas menores, aumenta a proporção do card
    } else {
      return 0.7; // Para telas maiores, mantém a proporção padrão
    }
  }

  String _getReleaseDate(Map<String, dynamic> item) {
    if (item['release_date'] != null) {
      return item['release_date'].split('-')[0];
    } else if (item['first_air_date'] != null) {
      return item['first_air_date'].split('-')[0];
    } else {
      return 'Desconhecido';
    }
  }
}
