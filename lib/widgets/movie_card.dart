import 'package:flutter/material.dart';
import '../pages/details_page.dart';

// Sobre este arquivo:
// - É utilizado para exibir informações de um filme de forma estruturada e estilizada.
// - Encapsula a apresentação de detalhes como título, imagem do poster e data de lançamento, seguindo o layout e estilo definidos no design da aplicação.
// - Este widget é reutilizado em várias partes da interface onde cards de filmes são necessários, mantendo o código organizado e promovendo a reutilização de código.

class MovieCard extends StatelessWidget {
  final String title;
  final String posterUrl;
  final String releaseDate;
  final Map<String, dynamic> item;

  const MovieCard({
    Key? key,
    required this.title,
    required this.posterUrl,
    required this.releaseDate,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: EdgeInsets.symmetric(horizontal: 4),
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
          SizedBox(height: 4),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Lançamento: $releaseDate',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(item: item),
                  ),
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
          ),
        ],
      ),
    );
  }
}
