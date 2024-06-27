import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/saved_items_provider.dart';
import '../services/tmdb_service.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const DetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isSaved = false;
  Map<String, dynamic>? movieDetails;
  String? trailerUrl;
  List<dynamic>? cast;

  @override
  void initState() {
    super.initState();
    final savedItemsProvider =
        Provider.of<SavedItemsProvider>(context, listen: false);
    isSaved = savedItemsProvider.isSaved(widget.item);
    _fetchMovieDetails();
  }

  Future<void> _fetchMovieDetails() async {
    final tmdbService = TmdbService();
    final int movieId = int.parse(widget.item['id'].toString());

    final details = await tmdbService.getMovieDetails(movieId);
    final trailer = await tmdbService.getMovieTrailer(movieId);
    final credits = await tmdbService.getMovieCredits(movieId);

    setState(() {
      movieDetails = details;
      trailerUrl = trailer;
      cast = credits['cast'] != null ? List<dynamic>.from(credits['cast']) : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.item['title'] ?? widget.item['name'] ?? 'Detalhes'),
        backgroundColor: Colors.black,
      ),
      body: movieDetails == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPoster(),
                  SizedBox(height: 16),
                  _buildTitle(),
                  SizedBox(height: 16),
                  _buildDescription(),
                  SizedBox(height: 16),
                  _buildTrailerButton(),
                  SizedBox(height: 16),
                  _buildCast(),
                  SizedBox(height: 16),
                  _buildLanguageAndAuthors(),
                  SizedBox(height: 16),
                  _buildOriginalTitleBudgetRevenue(),
                  SizedBox(height: 16),
                  _buildRating(),
                  SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildPoster() {
    String posterPath = widget.item['poster_path'];
    return Center(
      child: SizedBox(
        width: 200,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.item['media_type'] == 'movie' ? 'Filme' : 'Série de TV',
          style: TextStyle(
            fontSize: 14,
            color: Colors.orange,
          ),
        ),
        SizedBox(height: 8),
        Text(
          widget.item['title'] ?? widget.item['name'] ?? 'Título Desconhecido',
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
                Row(
                  children: [
                    Text(
                      _getDuration(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      _getStatus(),
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
    );
  }

  Widget _buildDescription() {
    String overview = movieDetails?['overview'] ?? 'Descrição não disponível.';
    return Text(
      overview,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTrailerButton() {
  return ElevatedButton(
    onPressed: () {
      if (trailerUrl != null && trailerUrl!.isNotEmpty) {
        _launchURL(trailerUrl!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Trailer não disponível'),
          ),
        );
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red, 
      minimumSize: Size(double.infinity, 48), 
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0), // Espaçamento interno
      child: Text(
        'Assistir Trailer',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ),
  );
}


  Widget _buildCast() {
  if (cast != null && cast!.isNotEmpty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          ' Elenco ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: cast!.map<Widget>((actor) {
              String? profilePath = actor['profile_path'] as String?;
              String name = actor['name'] ?? 'Nome não disponível';
              String character = actor['character'] ?? 'Personagem não disponível';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: profilePath != null
                          ? NetworkImage(
                              'https://image.tmdb.org/t/p/w200$profilePath',
                            )
                          : AssetImage('assets/images/default_profile_image.png') as ImageProvider,
                    ),
                    SizedBox(height: 8),
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      character,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  } else {
    return Text(
      'Elenco não disponível',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
}




  Widget _buildLanguageAndAuthors() {
    String language =
        movieDetails?['original_language'] ?? 'Não especificado';
    String authors = _getAuthors();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            'Idioma: $language',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            'Autores e Direção: $authors',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOriginalTitleBudgetRevenue() {
    String originalTitle = movieDetails?['original_title'] ?? 'Não especificado';
    String budget = movieDetails?['budget'] != null
        ? '\$${movieDetails!['budget'].toString()}'
        : 'Não especificado';
    String revenue = movieDetails?['revenue'] != null
        ? '\$${movieDetails!['revenue'].toString()}'
        : 'Não especificado';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            'Título Original: $originalTitle',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Orçamento: $budget',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Bilheteria: $revenue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRating() {
    double rating = movieDetails?['vote_average'] ?? 0.0;
    int voteCount = movieDetails?['vote_count'] ?? 0;
    return Text(
      'Classificação Geral: $rating/10 ($voteCount votos)',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  String _getReleaseYear() {
    String releaseDate = movieDetails?['release_date'] ??
        movieDetails?['first_air_date'] ??
        'Não especificado';
    return releaseDate.isNotEmpty
        ? releaseDate.substring(0, 4)
        : 'Não especificado';
  }

  String _getRating() {
    double rating = movieDetails?['vote_average'] ?? 0.0;
    return rating.toStringAsFixed(1);
  }

  String _getAgeRestriction() {
    String certification = 'Não especificado';
    List<dynamic>? releaseDates = movieDetails?['release_dates']?['results'];

    if (releaseDates != null) {
      for (var result in releaseDates) {
        if (result['iso_3166_1'] == 'BR') {
          var certifications = result['release_dates'];
          for (var cert in certifications) {
            if (cert['certification'] != null &&
                cert['certification'].isNotEmpty) {
              certification = cert['certification'];
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
    int runtime = movieDetails?['runtime'] ?? 0;
    int minutes = runtime % 60;
    int hours = (runtime / 60).floor();
    return '${hours}h${minutes}min';
  }

  String _getStatus() {
    String status = movieDetails?['status'] ?? 'Desconhecido';
    return status.isNotEmpty ? status : 'Desconhecido';
  }

  String _getAuthors() {
    List<dynamic>? crew = cast != null
        ? cast!.where((member) => member['known_for_department'] == 'Directing' || member['known_for_department'] == 'Writing').toList()
        : [];

    if (crew.isNotEmpty) {
      String authorsList = crew.map((author) => author['name']).take(5).join(', ');
      return authorsList;
    } else {
      return 'Não especificado';
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

