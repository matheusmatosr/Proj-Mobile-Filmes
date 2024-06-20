import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const DetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(item['title'] ?? item['name'] ?? 'Detalhes'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPoster(context),
            SizedBox(height: 5),
            _buildTitlesRow(context),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildDescription(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster(BuildContext context) {
    String posterPath = item['poster_path'];
    return Image.network(
      'https://image.tmdb.org/t/p/w500$posterPath',
      fit: BoxFit.contain,
      width: MediaQuery.of(context).size.width,
      height: 300,
    );
  }

  Widget _buildTitlesRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filmes',
            style: TextStyle(
              fontSize: 14,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['title'] ?? item['name'] ?? 'Título Desconhecido',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.bookmark,
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    String overview = item['overview'] ?? 'Descrição não disponível.';
    return Text(
      overview,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
}
