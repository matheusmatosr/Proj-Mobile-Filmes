import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../pages/details_page.dart';

// Sobre este arquivo:
// - É utilizado para exibir informações de um filme de forma estruturada e estilizada. 
// - Encapsula a apresentação de detalhes como título, imagem do poster e data de lançamento, seguindo o layout e estilo definidos no design da aplicação.
// - Este widget é reutilizado em várias partes da interface onde cards de filmes são necessários, mantendo o código organizado e promovendo a reutilização de código.

class MovieCard extends StatelessWidget {
  final String title;
  final String posterUrl;
  final String releaseDate;

  const MovieCard({
    Key? key,
    required this.title,
    required this.posterUrl,
    required this.releaseDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, // Ajusta a largura do card
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // Aumenta o padding do card
      margin: EdgeInsets.symmetric(horizontal: 4), // Aumenta o espaçamento lateral entre os cards
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              posterUrl,
              width: 120,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10), // Aumenta o espaçamento entre a imagem e o título
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Lançamento: $releaseDate',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10), // Aumenta o espaçamento entre o título e o botão de detalhes
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailsPage(item: {},)),
              );
            },
            child: Text(
              'Detalhes',
              style: TextStyle(
                color: Colors.red,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
