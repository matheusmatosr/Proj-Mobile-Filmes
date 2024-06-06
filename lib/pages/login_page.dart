import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final Function(String) onLogin;

  const LoginPage({Key? key, required this.onLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String username = '';
    String password = '';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            Center(
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Cine',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'UCL+',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bem-vindo(a) de novo!',
              style: TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Usuário',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white,
                filled: true,
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                username = value;
              },
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white,
                filled: true,
              ),
              style: const TextStyle(color: Colors.black),
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Simulação de login bem-sucedido
                onLogin(username);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(150, 50),
                foregroundColor: Colors.white,
              ),
              child: const Text('Entrar'),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Não tem uma conta?',
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Registre',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
