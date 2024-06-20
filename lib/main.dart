import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/main_page.dart';
import 'pages/save_page.dart';
import 'providers/movie_provider.dart';
import 'providers/saved_items_provider.dart';
import 'services/tmdb_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return MultiProvider(
      // Usar MultiProvider para envolver toda a aplicação com múltiplos providers
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                MovieProvider(TmdbService())), // Inicializa o MovieProvider
        ChangeNotifierProvider(
            create: (_) =>
                SavedItemsProvider()), // Inicializa o SavedItemsProvider
      ],
      child: MaterialApp(
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
          '/home': (context) =>
              MainPage(username: username!), // Passa o username para MainPage
          '/saved': (context) =>
              const SavePage(), // Adiciona a rota para SavePage
        },
      ),
    );
  }
}
