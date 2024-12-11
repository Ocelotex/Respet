import 'package:flutter/material.dart';
import 'package:flutter_projetinho/view/reportDetailsView.dart';
import '/report.dart';

class ReportListView extends StatefulWidget {
  final ReportManager reportManager;
  final String userId;

  const ReportListView({
    required this.reportManager,
    required this.userId,
  });

  @override
  _ReportListViewState createState() => _ReportListViewState();
}

class _ReportListViewState extends State<ReportListView> {
  void onDeleteDenuncia(Report denuncia) {
    widget.reportManager.removerDenuncia(denuncia);
    _updateDenuncias();
  }

  void onUpdateDenuncia() {
    _updateDenuncias(); 
  }

  void _updateDenuncias() {
    widget.reportManager.carregarDenuncias(widget.userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Lista de Denúncias'),
      ),
      body: FutureBuilder(
        future: widget.reportManager.carregarDenuncias(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: widget.reportManager.denunciasUsuario.length,
              itemBuilder: (context, index) {
                final denuncia = widget.reportManager.denunciasUsuario[index];
                return ListTile(
                  title: Text('Denúncia: ${denuncia.descricao}'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReportDetailsView(
                          denuncia: denuncia,
                          onDelete: () => onDeleteDenuncia(denuncia),
                          onUpdate: onUpdateDenuncia,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
