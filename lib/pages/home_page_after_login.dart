import 'package:flutter/material.dart';

class HomePageAfterLogin extends StatelessWidget {
  final String username;

  const HomePageAfterLogin({Key? key, required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('CineUCL+'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navegar para a página inicial
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Olá, $username',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implemente a navegação para a próxima página
              },
              child: Text('Próxima Página'),
            ),
          ],
        ),
      ),
    );
  }
}
