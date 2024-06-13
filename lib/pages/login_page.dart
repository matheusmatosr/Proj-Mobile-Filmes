import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final Function(String) onLogin;

  const LoginPage({Key? key, required this.onLogin}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      widget.onLogin(_usernameController.text);
      Navigator.pushNamed(
          context, '/home'); // Assuming '/home' is the home screen route
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao entrar: ${e.message}')),
      );
    }
  }

  void _resetPassword() {
    if (_usernameController.text.isNotEmpty) {
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: _usernameController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Link para resetar a senha enviado para o seu e-mail')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu e-mail')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuário',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white,
                filled: true,
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white,
                filled: true,
              ),
              style: const TextStyle(color: Colors.black),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _login,
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
                const Text('Não tem uma conta?',
                    style: TextStyle(color: Colors.white)),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Registre',
                      style: TextStyle(color: Colors.red)),
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
