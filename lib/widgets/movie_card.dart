import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              posterUrl,
              width: 100.0,
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 4.0),
          Text(
            releaseDate,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
