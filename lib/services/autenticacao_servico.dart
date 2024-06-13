import 'package:firebase_auth/firebase_auth.dart';

class AutenticacaoServico {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> cadastrarUsuario({
    required String nome,
    required String senha,
    required String email,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      print("Usuário cadastrado: ${userCredential.user?.uid}");
    } catch (e) {
      print('Erro ao cadastrar usuário: $e');
      rethrow;
    }
  }
}
