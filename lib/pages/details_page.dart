import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Importe o pacote url_launcher
import '../providers/saved_items_provider.dart';
import '../services/tmdb_service.dart'; // Importe a classe de serviço

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPoster(context),
                  SizedBox(height: 16),
                  _buildTitle(context),
                  SizedBox(height: 16),
                  _buildDescription(),
                  SizedBox(height: 16),
                  _buildAdditionalDetails(),
                ],
              ),
            ),
    );
  }

  Widget _buildPoster(BuildContext context) {
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

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                widget.item['title'] ??
                    widget.item['name'] ??
                    'Título Desconhecido',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
          IconButton(
            icon: Icon(
              Icons.bookmark,
              color: isSaved ? Colors.red : Colors.red.withOpacity(0.5),
              size: 30,
            ),
            onPressed: () {
              setState(() {
                isSaved = !isSaved;
              });
              final savedItemsProvider =
                  Provider.of<SavedItemsProvider>(context, listen: false);
              if (isSaved) {
                savedItemsProvider.addSavedItem(widget.item);
              } else {
                savedItemsProvider.removeSavedItem(widget.item);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    String overview = movieDetails?['overview'] ?? 'Descrição não disponível.';
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

  Widget _buildAdditionalDetails() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Classificação Geral:'),
        _buildRating(),
        SizedBox(height: 16),
        _buildSectionTitle('Autores e Direção:'),
        _buildAuthorsAndDirectors(),
        SizedBox(height: 16),
        _buildSectionTitle('Título Original:'),
        _buildOriginalTitle(),
        SizedBox(height: 16),
        _buildSectionTitle('Estado:'),
        _buildStatus(),
        SizedBox(height: 16),
        _buildSectionTitle('Idioma:'),
        _buildLanguage(),
        SizedBox(height: 16),
        _buildSectionTitle('Orçamento:'),
        _buildBudget(),
        SizedBox(height: 16),
        _buildSectionTitle('Bilheteira:'),
        _buildRevenue(),
        SizedBox(height: 16),
        _buildSectionTitle('Elenco:'),
        _buildCast(),
        SizedBox(height: 16),
        _buildSectionTitle('Trailer:'),
        _buildTrailerButton(),
      ],
    ),
  );
}

  Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
}
  Widget _buildRating() {
  double rating = movieDetails?['vote_average'] ?? 0.0;
  int voteCount = movieDetails?['vote_count'] ?? 0;
  return Text(
    '$rating/10 ($voteCount votos)',
    style: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  );
}

  Widget _buildAuthorsAndDirectors() {
  if (movieDetails != null) {
    List<dynamic> directors = movieDetails!['credits']['crew']
        .where((crewMember) => crewMember['job'] == 'Director')
        .toList();
    List<dynamic> authors = movieDetails!['credits']['crew']
        .where((crewMember) => crewMember['department'] == 'Writing')
        .toList();

    String directorsString =
        directors.map((director) => director['name']).join(', ');
    String authorsString =
        authors.map((author) => author['name']).join(', ');

    return Text(
      'Diretor(es): $directorsString\nAutor(es): $authorsString',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  } else {
    return Text(
      'Não disponível',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
}


  Widget _buildOriginalTitle() {
  String originalTitle = movieDetails?['original_title'] ?? 'Não especificado';
  return Text(
    originalTitle,
    style: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  );
}

  Widget _buildStatus() {
  String status = movieDetails?['status'] ?? 'Não especificado';
  return Text(
    status,
    style: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  );
}

Widget _buildLanguage() {
  String language = movieDetails?['original_language'] ?? 'Não especificado';
  return Text(
    language,
    style: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  );
}

  Widget _buildBudget() {
  int budget = movieDetails?['budget'] ?? 0;
  return Text(
    '\$${budget.toStringAsFixed(2)}',
    style: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  );
}

Widget _buildRevenue() {
  int revenue = movieDetails?['revenue'] ?? 0;
  return Text(
    '\$${revenue.toStringAsFixed(2)}',
    style: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  );
}

  Widget _buildCast() {
  if (cast != null && cast!.isNotEmpty) {
    String castList =
        cast!.map((actor) => actor['name']).take(5).join(', ');
    return Text(
      castList,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  } else {
    return Text(
      'Não disponível',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
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
    child: Text(
      'Assistir Trailer',
      style: TextStyle(
        fontSize: 16,
      ),
    ),
  );
}

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
            if (cert['certification'] != null && cert['certification'].isNotEmpty) {
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
    int hours = runtime ~/ 60;
    int minutes = runtime % 60;
    String duration = hours > 0 ? '$hours h $minutes min' : '$minutes min';
    return duration;
  }
}
