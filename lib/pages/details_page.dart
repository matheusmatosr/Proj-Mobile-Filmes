import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/saved_items_provider.dart'; 
import '../services/tmdb_service.dart';  // Supondo que você tenha um serviço TMDB para buscar os detalhes completos

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const DetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isSaved = false;
  Map<String, dynamic>? detailedItem;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetailedInfo();
  }

  Future<void> _fetchDetailedInfo() async {
    final tmdbService = TmdbService(); 
    final savedItemsProvider = Provider.of<SavedItemsProvider>(context, listen: false);
    isSaved = savedItemsProvider.isSaved(widget.item);

    final movieId = widget.item['id'];
    final mediaType = widget.item['media_type'];  // 'movie' ou 'tv'
    final details = await tmdbService.fetchDetails(movieId, mediaType);
    setState(() {
      detailedItem = details;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.item['title'] ?? widget.item['name'] ?? 'Detalhes'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved ? Colors.red : Colors.red.withOpacity(0.5),
              size: 30,
            ),
            onPressed: () {
              setState(() {
                isSaved = !isSaved;
              });
              final savedItemsProvider = Provider.of<SavedItemsProvider>(context, listen: false);
              if (isSaved) {
                savedItemsProvider.addSavedItem(widget.item);
              } else {
                savedItemsProvider.removeSavedItem(widget.item);
              }
            },
          ),
        ],
      ),
      body: isLoading 
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPoster(),
              SizedBox(height: 16),
              _buildTitle(),
              SizedBox(height: 16),
              _buildDescription(),
              SizedBox(height: 16),
              _buildCast(),
              SizedBox(height: 16),
              _buildReviews(),
            ],
          ),
        ),
    );
  }

  Widget _buildPoster() {
    String posterPath = detailedItem?['poster_path'] ?? '';
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 300,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            'https://image.tmdb.org/t/p/w500$posterPath',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detailedItem?['media_type'] == 'movie' ? 'Filme' : 'Série de TV',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 8),
              Text(
                detailedItem?['title'] ?? detailedItem?['name'] ?? 'Título Desconhecido',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
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
    );
  }

  Widget _buildDescription() {
    String overview = detailedItem?['overview'] ?? 'Descrição não disponível.';
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

  Widget _buildCast() {
    List<dynamic> cast = detailedItem?['credits']['cast'] ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Elenco',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: cast.map((actor) {
                return Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${actor['profile_path']}',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        actor['name'],
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    List<dynamic> reviews = detailedItem?['reviews']['results'] ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Avaliações e críticas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                _getRating(),
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '(${reviews.length} Reviews)',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Column(
            children: reviews.map((review) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          review['rating'].toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      review['content'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      review['author'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getReleaseYear() {
    String releaseDate = detailedItem?['release_date'] ??
        detailedItem?['first_air_date'] ??
        'Não especificado';
    return releaseDate.isNotEmpty
        ? releaseDate.substring(0, 4)
        : 'Não especificado';
  }

  String _getRating() {
    double rating = detailedItem?['vote_average']?.toDouble() ?? 0.0;
    return rating.toStringAsFixed(1);
  }

  String _getAgeRestriction() {
    return detailedItem?['adult'] == true ? '18+' : 'Livre';
  }

  String _getDuration() {
    if (detailedItem?['media_type'] == 'movie') {
      int runtime = detailedItem?['runtime'] ?? 0;
      int hours = runtime ~/ 60;
      int minutes = runtime % 60;
      return hours > 0
          ? '${hours}h ${minutes}m'
          : '${minutes}m';
    } else {
      int numberOfSeasons = detailedItem?['number_of_seasons'] ?? 0;
      return '${numberOfSeasons} Temporada${numberOfSeasons > 1 ? 's' : ''}';
    }
  }
}
