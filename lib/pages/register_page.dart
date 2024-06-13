import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  final Function(String) onRegister;

  const RegisterPage({Key? key, required this.onRegister}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      widget.onRegister(_usernameController.text);
      Navigator.pushNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao registrar: ${e.message}')),
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
            const Center(
              child: Text(
                'Cadastre-se',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Endereço de email',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white,
                filled: true,
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white,
                filled: true,
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
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
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(150, 50),
                foregroundColor: Colors.white,
              ),
              child: const Text('Criar Conta'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Já possui uma conta?',
                      style: TextStyle(color: Colors.white)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Entrar',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
