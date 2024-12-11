import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Aplicativo'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                  'Tema Escolhido: Aplicativo de Resgate de Animais de Rua'),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                  'Objetivo: Denunciar animais de rua e ajudar a comunidade'),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Desenvolvedor: Angelo Marcari'),
            ),
            Padding(
              padding: const EdgeInsets.all(100.0),
              child: Image.asset('assets/images/developer_photo.png'),
            ),
          ],
        ),
      ),
    );
  }
}
