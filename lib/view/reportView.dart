import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projetinho/view/userProfileView.dart';
import 'package:flutter_projetinho/view/reportListView.dart';
import '/report.dart';

class ReportView extends StatefulWidget {
  final ReportManager reportManager;

  const ReportView({required this.reportManager});

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  final TextEditingController dataController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  void _enviarDenuncia() async {
    final novaDenuncia = Report(
      uid: FirebaseAuth.instance.currentUser!.uid,
      data: dataController.text,
      local: localController.text,
      descricao: descricaoController.text,
      id: '',
    );

    await widget.reportManager.criarDenuncia(novaDenuncia);

    dataController.clear();
    localController.clear();
    descricaoController.clear();

    await widget.reportManager.carregarDenuncias(novaDenuncia.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Fazer Denúncia'),
        leading: IconButton(
          icon: Icon(Icons.list),
          onPressed: () async {
            await widget.reportManager.carregarDenuncias(FirebaseAuth.instance.currentUser!.uid);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReportListView(
                  reportManager: widget.reportManager,
                  userId: FirebaseAuth.instance.currentUser!.uid,
                ),
              ),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfileView(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: dataController,
              decoration: const InputDecoration(
                labelText: 'Data',
              ),
            ),
            TextField(
              controller: localController,
              decoration: const InputDecoration(
                labelText: 'Local',
              ),
            ),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição do Animal',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _enviarDenuncia,
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              child: const Text('Enviar Denúncia'),
            ),
          ],
        ),
      ),
    );
  }
}
