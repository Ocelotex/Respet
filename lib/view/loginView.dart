import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/view/forgotView.dart';
import 'registerView.dart';

class LoginView extends StatelessWidget {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtSenha = TextEditingController();

  void login(BuildContext context, String email, String senha) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((res) {
      sucesso(context, 'Usuário autenticado com sucesso.');
      Navigator.pushReplacementNamed(context, '/report');
    }).catchError((e) {
      switch (e.code) {
        case 'invalid-email':
          erro(context, 'Email é inválido.');
          break;
        case 'user-not-found':
          erro(context, 'Usuário não encontrado.');
          break;
        case 'wrong-password':
          erro(context, 'Senha incorreta.');
          break;
        default:
          erro(context, e.code.toString());
      }
    });
  }

  void sucesso(BuildContext context, String mensagem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void erro(BuildContext context, String mensagem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Login'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              height: 240.0,
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: txtEmail,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: txtSenha,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 16.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(220, 50),
                // ignore: deprecated_member_use
                primary: Colors.orange,
                side: const BorderSide(color: Colors.orange),
              ),
              onPressed: () {
                login(
                  context,
                  txtEmail.text,
                  txtSenha.text,
                );
              },
              child: const Text(
                'Entrar',
                style: TextStyle(color: Colors.orange),
              ),
            ),
            const SizedBox(height: 220.0),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ForgotPasswordView();
                }));
              },
              child: const Text(
                'Esqueci a Senha',
                style: TextStyle(
                  color: Colors.orange,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Não possui uma conta? ',
                  ),
                  TextSpan(
                    text: 'Registre-se',
                    style: const TextStyle(
                      color: Colors.orange,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RegisterView();
                        }));
                      },
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
