import 'package:cloud_firestore/cloud_firestore.dart';

class PedidosProviders {
  // ...

  Stream<List<DocumentSnapshot>> streamPedidos(int estadoid) {
    return FirebaseFirestore.instance
        .collection('pedidos')
        .where('estadoid', isEqualTo: estadoid)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }
}

