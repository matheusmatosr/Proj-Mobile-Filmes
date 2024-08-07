import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/saved_items_provider.dart';
import '../widgets/movie_card.dart';

class SavePage extends StatelessWidget {
  const SavePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

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
                childAspectRatio: isMobile ? 0.6 : 0.7,
              ),
              itemCount: savedItems.length,
              itemBuilder: (context, index) {
                final item = savedItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: MovieCard(
                    title:
                        item['title'] ?? item['name'] ?? 'Título Desconhecido',
                    posterUrl:
                        'https://image.tmdb.org/t/p/w200${item['poster_path']}',
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
          /*BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.red),
            label: '',
          ),*/
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/saved');
          }
        },
      ),
    );
  }
}
