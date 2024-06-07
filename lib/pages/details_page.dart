import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const DetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['title'] ?? item['name'] ?? 'Detalhes'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPoster(context),
              SizedBox(height: 16),
              _buildTitle(context),
              SizedBox(height: 8),
              _buildDescription(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoster(BuildContext context) {
    String posterPath = item['poster_path'];
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        'https://image.tmdb.org/t/p/w200$posterPath',
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: 300,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      item['title'] ?? item['name'] ?? 'Título Desconhecido',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
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
