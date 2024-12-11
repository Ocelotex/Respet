import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/report.dart';

class ReportDetailsView extends StatefulWidget {
  final Report denuncia;
  final Function onDelete;
  final Function onUpdate;

  const ReportDetailsView({
    required this.denuncia,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  _ReportDetailsViewState createState() => _ReportDetailsViewState();
}

class _ReportDetailsViewState extends State<ReportDetailsView> {
  late TextEditingController dataController;
  late TextEditingController localController;
  late TextEditingController descricaoController;

  @override
  void initState() {
    super.initState();
    dataController = TextEditingController(text: widget.denuncia.data);
    localController = TextEditingController(text: widget.denuncia.local);
    descricaoController =
        TextEditingController(text: widget.denuncia.descricao);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Detalhes da Denúncia'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteDenuncia();
              widget.onDelete();
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _editDenuncia(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Denúncia: ${widget.denuncia.descricao}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Data: ${widget.denuncia.data}'),
            Text('Local: ${widget.denuncia.local}'),
          ],
        ),
      ),
    );
  }

  void _deleteDenuncia() {
    FirebaseFirestore.instance
        .collection('Denuncias')
        .doc(widget.denuncia.id)
        .delete();
  }

  void _editDenuncia(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Denúncia'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: dataController,
                  decoration: InputDecoration(labelText: 'Data'),
                ),
                TextField(
                  controller: localController,
                  decoration: InputDecoration(labelText: 'Local'),
                ),
                TextField(
                  controller: descricaoController,
                  decoration: InputDecoration(labelText: 'Descrição do Animal'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _updateDenuncia();
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _updateDenuncia() {
    FirebaseFirestore.instance
        .collection('Denuncias')
        .doc(widget.denuncia.id)
        .update({
      'data': dataController.text,
      'local': localController.text,
      'descricao': descricaoController.text,
    }).then((_) {
      widget.onUpdate(); 
      Navigator.pop(context); 
    });
  }
}
