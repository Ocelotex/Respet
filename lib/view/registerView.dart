import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void criarConta(BuildContext context) {
    String nome = nameController.text;
    String email = emailController.text;
    String senha = passwordController.text;

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((res) {
      FirebaseFirestore.instance.collection('usuarios').add({
        "uid": res.user!.uid.toString(),
        "nome": nome,
      });
      sucesso(context, 'Usuário criado com sucesso.');
      Navigator.pushReplacementNamed(context, '/login');
    }).catchError((e) {
      switch (e.code) {
        case 'email-already-in-use':
          erro(context, 'O email já foi cadastrado.');
          break;
        case 'invalid-email':
          erro(context, 'O email é inválido.');
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
          title: Text('Sucesso'),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('OK'),
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
          title: Text('Erro'),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
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
        title: Text('Registro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                criarConta(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
