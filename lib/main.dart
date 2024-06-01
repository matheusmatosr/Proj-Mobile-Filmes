import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuthenticated = false;
  String? username;

  void login(String username) {
    setState(() {
      isAuthenticated = true;
      this.username = username;
    });
  }

  void logout() {
    setState(() {
      isAuthenticated = false;
      username = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineUCL+',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => LoginPage(onLogin: (username) {
              login(username);
              Navigator.pushReplacementNamed(context, '/home');
            }),
        '/register': (context) => RegisterPage(onRegister: (username) {
              Navigator.pop(context);
            }),
        '/home': (context) => MainPage(username: username!),
      },
    );
  }
}
