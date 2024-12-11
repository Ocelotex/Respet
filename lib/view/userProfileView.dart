import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileView extends StatefulWidget {
  final User? user;

  UserProfileView({Key? key, this.user}) : super(key: key);

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  late String _userName;
  late TextEditingController _nameController;
  bool _showSuccessMessage = false;

  @override
  void initState() {
    super.initState();
    _userName = '';
    _nameController = TextEditingController();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .where('uid', isEqualTo: currentUser.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final data = querySnapshot.docs.first.data() as Map<String, dynamic>?;

          setState(() {
            _userName = data?['nome'] ?? 'Nome não encontrado';
          });
        } else {
          setState(() {
            _userName = 'Nome não encontrado';
          });
        }
      } else {
        setState(() {
          _userName = 'Usuário não autenticado';
        });
      }
    } catch (e) {
      setState(() {
        _userName = 'Erro ao obter o nome do usuário';
      });
    }
  }

  void _changeUserName() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Trocar Nome'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Novo Nome'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String newName = _nameController.text.trim();

                if (newName.isNotEmpty) {
                  User? currentUser = FirebaseAuth.instance.currentUser;

                  if (currentUser != null) {
                    QuerySnapshot querySnapshot = await FirebaseFirestore
                        .instance
                        .collection('usuarios')
                        .where('uid', isEqualTo: currentUser.uid)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      DocumentSnapshot document = querySnapshot.docs.first;

                      await document.reference.update({'nome': newName});

                      setState(() {
                        _userName = newName;
                        _showSuccessMessage = true;
                      });

                      Future.delayed(Duration(seconds: 2), () {
                        setState(() {
                          _showSuccessMessage = false;
                        });
                      });

                      Navigator.pop(context);
                    }
                  }
                }
              },
              child: Text('Salvar'),
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
        title: Text('Perfil'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                _userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _changeUserName,
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
                child: Text('Trocar Nome'),
              ),
              SizedBox(height: 16.0),
              if (_showSuccessMessage)
                Text(
                  'Nome alterado com sucesso!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
