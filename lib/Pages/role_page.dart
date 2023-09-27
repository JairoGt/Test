// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  _RolePageState createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DocumentSnapshot> _usersList = [];

  String role = '';

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  void _getUsers() async {
    QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
    _usersList = usersSnapshot.docs;
    if (mounted) {
      setState(() {});
    }
  }

  void _updateRole(String email, String role) async {
    DocumentReference userDocument = _firestore.collection('users').doc(email);
    Map<String, dynamic> data = {
      'role': role,
    };
    if (role == 'moto') {
      String id = _getRandomId(3);
      data['idmoto'] = id;
    }
    await userDocument.update(data);
    _getUsers();
  }

  String _getRandomId(int length) {
    var random = Random();
    var digits = List.generate(length, (_) => random.nextInt(10));
    return digits.join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambio de Roles'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _usersList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot user = _usersList[index];
                  return ListTile(
                    title: Text(user['name']),
                    subtitle: Text(user['role']),
                    trailing: PopupMenuButton(
// Se quita el icono del lápiz.
                      icon: const Icon(Icons.change_history),
                      itemBuilder: (BuildContext context) => [
// Se agregan las opciones de rol.
                        const PopupMenuItem(
                          value: 'admin',
                          child: Text('Admin'),
                        ),
                        const PopupMenuItem(
                          value: 'client',
                          child: Text('Cliente'),
                        ),
                        const PopupMenuItem(
                          value: 'moto',
                          child: Text('Moto'),
                        ),
                      ],
                      onSelected: (role) {
// Se muestra un mensaje de confirmación.
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('¿Desea realizar el cambio? a $role'),
                            actions: [
                           
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
// Se asigna la selección actual a la variable _selectedRole.
// Se llama a la función _updateRole() para actualizar el rol del usuario.
                                  if(mounted){
                                    setState(() {
                                      
                                    });
                                  }

                                  _updateRole(user['email'], role);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}