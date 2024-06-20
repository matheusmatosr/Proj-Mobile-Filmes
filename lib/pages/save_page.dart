import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/saved_items_provider.dart';
import '../widgets/movie_card.dart';

class SavePage extends StatelessWidget {
  const SavePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Filmes e Séries Salvos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<SavedItemsProvider>(
          builder: (context, savedItemsProvider, child) {
            final savedItems = savedItemsProvider.savedItems;
            if (savedItems.isEmpty) {
              return Center(
                child: Text(
                  'Nenhum item salvo.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                childAspectRatio: 0.7,
              ),
              itemCount: savedItems.length,
              itemBuilder: (context, index) {
                final item = savedItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: MovieCard(
                    title: item['title'] ?? item['name'] ?? 'Título Desconhecido',
                    posterUrl: 'https://image.tmdb.org/t/p/w200${item['poster_path']}',
                    releaseDate: item['release_date'] != null
                        ? item['release_date'].split('-')[0]
                        : item['first_air_date'] != null
                            ? item['first_air_date'].split('-')[0]
                            : 'Desconhecido',
                    item: item,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
