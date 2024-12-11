import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String id;
  String data;
  String local;
  String descricao;
  String uid;

  Report({
    required this.id,
    required this.data,
    required this.local,
    required this.descricao,
    required this.uid,
  });
}

class ReportManager {
  List<Report> denunciasUsuario = [];

  Future<void> criarDenuncia(Report denuncia) async {
    try {
      DocumentReference documentReference =
          await FirebaseFirestore.instance.collection('Denuncias').add({
        'data': denuncia.data,
        'local': denuncia.local,
        'descricao': denuncia.descricao,
        'uid': denuncia.uid,
      });

      denuncia.id = documentReference.id;
      denunciasUsuario.add(denuncia);
    } catch (e) {
      print('Erro ao criar denúncia: $e');
    }
  }

  Future<void> carregarDenuncias(String uid) async {
    denunciasUsuario = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Denuncias')
        .where('uid', isEqualTo: uid)
        .get();

    denunciasUsuario = querySnapshot.docs
        .map((doc) => Report(
              id: doc.id,
              data: doc['data'],
              local: doc['local'],
              descricao: doc['descricao'],
              uid: doc['uid'],
            ))
        .toList();
  }

  Future<void> removerDenuncia(Report denuncia) async {
    await FirebaseFirestore.instance
        .collection('Denuncias')
        .doc(denuncia.id)
        .delete();
    denunciasUsuario.removeWhere((element) => element.id == denuncia.id);
  }

  Future<void> atualizarDenuncia(Report denuncia) async {
    await FirebaseFirestore.instance
        .collection('Denuncias')
        .doc(denuncia.id)
        .update({
      'data': denuncia.data,
      'local': denuncia.local,
      'descricao': denuncia.descricao,
    });

    int index =
        denunciasUsuario.indexWhere((element) => element.id == denuncia.id);
    if (index != -1) {
      denunciasUsuario[index] = denuncia;
    }
  }
}
