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

  void _toggleSavedStatus() {
    final savedItemsProvider =
        Provider.of<SavedItemsProvider>(context, listen: false);

    setState(() {
      isSaved = !isSaved;
      if (isSaved) {
        savedItemsProvider.addSavedItem(widget.item);
      } else {
        savedItemsProvider.removeSavedItem(widget.item);
      }
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
              color: Colors.red,
            ),
            onPressed: _toggleSavedStatus,
          ),
        ],
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
        padding:
            const EdgeInsets.symmetric(vertical: 16.0), // Espaçamento interno
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
                String character =
                    actor['character'] ?? 'Personagem não disponível';
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
                            : AssetImage(
                                    'assets/images/default_profile_image.png')
                                as ImageProvider,
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
    String language = movieDetails?['original_language'] ?? 'Não especificado';
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
    String originalTitle =
        movieDetails?['original_title'] ?? 'Não especificado';
    String budget = movieDetails?['budget'] != null
        ? '\$${movieDetails!['budget']}'
        : 'Não especificado';
    String revenue = movieDetails?['revenue'] != null
        ? '\$${movieDetails!['revenue']}'
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
          child: Text(
            'Orçamento: $budget\nReceita: $revenue',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRating() {
    String rating = _getRating();

    return Text(
      'Avaliação: $rating',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link $url';
    }
  }

  String _getReleaseYear() {
    String releaseDate = widget.item['release_date'] ?? '';
    if (releaseDate.isNotEmpty) {
      return releaseDate.split('-')[0];
    } else {
      return 'Ano não disponível';
    }
  }

  String _getRating() {
    return widget.item['vote_average']?.toString() ?? 'N/A';
  }

  String _getAgeRestriction() {
    return movieDetails?['age_restriction'] ?? 'N/A';
  }

  String _getDuration() {
    int? runtime = movieDetails?['runtime'];
    if (runtime != null) {
      int hours = runtime ~/ 60;
      int minutes = runtime % 60;
      return '${hours}h ${minutes}m';
    } else {
      return 'Duração não disponível';
    }
  }

  String _getStatus() {
    return movieDetails?['status'] ?? 'Status não disponível';
  }

  String _getAuthors() {
    List<dynamic>? crew = movieDetails?['credits']['crew'];
    if (crew != null && crew.isNotEmpty) {
      List<String> directors = crew
          .where((member) => member['job'] == 'Director')
          .map((member) => member['name'] as String)
          .toList();
      return directors.join(', ');
    } else {
      return 'Não disponível';
    }
  }
}
