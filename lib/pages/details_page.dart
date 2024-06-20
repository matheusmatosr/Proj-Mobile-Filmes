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
            SizedBox(height: 16),
            _buildTitle(context),
            SizedBox(height: 16),
            _buildDescription(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster(BuildContext context) {
    String posterPath = item['poster_path'];
    return AspectRatio(
      aspectRatio: 2 / 2.5, // Reduzindo o aspectRatio para diminuir o tamanho
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(
          'https://image.tmdb.org/t/p/w500$posterPath',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['media_type'] == 'movie' ? 'Filme' : 'Série de TV',
            style: TextStyle(
              fontSize: 14,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 8),
          Text(
            item['title'] ?? item['name'] ?? 'Título Desconhecido',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    _getReleaseYear(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        _getRating(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        _getAgeRestriction(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        _getDuration(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    String overview = item['overview'] ?? 'Descrição não disponível.';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        overview,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  String _getReleaseYear() {
    String releaseDate = item['release_date'] ?? item['first_air_date'] ?? 'Não especificado';
    return releaseDate.isNotEmpty ? releaseDate.substring(0, 4) : 'Não especificado';
  }

  String _getRating() {
    double rating = item['vote_average'] ?? 0.0;
    return rating.toStringAsFixed(1);
  }

  String _getAgeRestriction() {
    String certification = 'Não especificado'; // Inicialmente assume como não especificado
    List<dynamic>? releaseDates = item['release_dates']?['results']; // Obtém as datas de lançamento

    // Busca pela certificação do país "US" (Estados Unidos) se disponível
    if (releaseDates != null) {
      for (var result in releaseDates) {
        if (result['iso_3166_1'] == 'US') {
          var certifications = result['release_dates'];
          for (var cert in certifications) {
            if (cert['type'] == 3) {
              certification = cert['certification'] ?? 'Não especificado';
              break;
            }
          }
          break;
        }
      }
    }

    return '($certification)';
  }

  String _getDuration() {
    int runtime = item['runtime'] ?? item['episode_run_time']?.first ?? 0;
    int hours = runtime ~/ 60;
    int minutes = runtime % 60;
    String duration = hours > 0 ? '$hours h $minutes min' : '$minutes min';
    return duration;
  }
}
