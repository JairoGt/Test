import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsuariosProvider extends ChangeNotifier {
  // Colección de usuarios en Firestore
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Lista de usuarios
  List<DocumentSnapshot> _usuarios = [];

  // Lista de motoristas
  List<DocumentSnapshot> _motoristas = [];

  // Obtiene la lista de usuarios
  Future<List<DocumentSnapshot>> getUsuarios() async {
    // Obtenemos la lista de usuarios de Firestore
    _usuarios = await _usersCollection.get().then((querySnapshot) {
      return querySnapshot.docs;
    });

    // Actualizamos la lista de usuarios
    notifyListeners();

    return _usuarios;
  }

  // Obtiene la lista de motoristas
  Future<List<DocumentSnapshot>> getMotoristas() async {
    // Obtenemos la lista de motoristas de Firestore
    _motoristas = await _usersCollection
        .where('role', isEqualTo: 'moto')
        .get()
        .then((querySnapshot) {
      return querySnapshot.docs;
    });

    // Actualizamos la lista de motoristas
    notifyListeners();

    return _motoristas;
  }

  static of(BuildContext context) {}
}
