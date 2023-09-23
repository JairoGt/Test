import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Importamos las bibliotecas necesarias
import 'package:cloud_firestore/cloud_firestore.dart';

String getGreeting() {
  final currentTime = DateTime.now();
  final hour = currentTime.hour;

  if (hour >= 5 && hour < 12) {
    return 'Buen día';
  } else if (hour >= 12 && hour < 18) {
    return 'Buena tarde';
  } else {
    return 'Buena noche';
  }
}

final user = FirebaseAuth.instance.currentUser;

final greeting = getGreeting();
final now = DateTime.now();
// Colección de pedidos
final pedidosRef = FirebaseFirestore.instance.collection('pedidos');
final motoristasRef = FirebaseFirestore.instance.collection('users');
final timestamp = Timestamp.fromDate(now);

// Clase principal de la aplicación
class MotoPage extends StatefulWidget {
  const MotoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MotoPageState createState() => _MotoPageState();
}

// Estado de la aplicación
class _MotoPageState extends State<MotoPage> {
  // Lista de pedidos asignados
  List<DocumentSnapshot> pedidosAsignados = [];
  List<DocumentSnapshot> motoristas = [];
  // ID del motorista
  late String _idMotorista = '0';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    // Obtener motoristas
    motoristasRef.snapshots().listen((snapshot) {
      motoristas = snapshot.docs;

      setState(() {});
    });
    // Obtener el ID del motorista

    _idMotorista = auth.currentUser!.email.toString();

    // Obtener pedidos asimoognados
    pedidosRef
        .where('idMotorista', isEqualTo: _idMotorista)
        .where('estadoid', isNotEqualTo: 4)
        .snapshots()
        .listen((snapshot) {
      pedidosAsignados = snapshot.docs;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(greeting,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        flexibleSpace: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  '${user!.displayName ?? '${user!.email}'}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              // Agregar más widgets aquí
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (mounted) {
                setState(() {});
              }
            },
            icon: const Icon(Icons.refresh_sharp),
            color: Colors.green,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Lista de pedidos asignados
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: pedidosAsignados.length,
                itemBuilder: (context, index) {
                  final pedido = pedidosAsignados[index];
                  return InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(pedido['estadoid'] == '1'
                                    ? Icons.hourglass_empty
                                    : pedido['estadoid'] == '2'
                                        ? Icons.e_mobiledata
                                        : pedido['estadoid'] == '3'
                                            ? Icons.check
                                            : Icons.motorcycle),
                                const SizedBox(width: 10),
                                Text(pedido['idpedidos']),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(pedido['direccion']),
                          ),
                          Expanded(
                            child: Text(
                              'Q${pedidosAsignados[index]['precioTotal']}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Pedido en camino?'),
                                content: const Text(
                                    'Ya salio el pedido de la tienda ?'),
                                actions: [
                                  ElevatedButton(
                                    child: const Text('SI'),
                                    onPressed: () async {
                                      if (pedido['estadoid'] == 2) {
                                        // Cambiar el estado del pedido a 'en camino'
                                        pedidosRef
                                            .doc(pedidosAsignados[index].id)
                                            .update({
                                          'estadoid': 3,
                                          'fechaCamino':
                                              Timestamp.fromDate(now),
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Pedido en Camino'),
                                          ),
                                        );
                                        Navigator.pop(context);
//Navigator.popAndPushNamed(context, '/motoasignado');
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Error estado no valida, comunicate con el administrador'),
                                          ),
                                        );
                                        Navigator.pop(context);
//Navigator.popAndPushNamed(context, '/motoasignado');
                                      }

                                      /*Navigator.of(context).pop();
if(pedido['estadoid']==2){
// Cambiar el estado del pedido a 'en camino'
pedidosRef.doc(pedidosAsignados[index].id).update({
'estadoid': 3,
'fechaCamino': Timestamp.fromDate(now),
});
Navigator.popAndPushNamed(context, '/motoasignado');

} else{
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('El Pedido ya fue Marcado como EN Camino'),
),
);
Navigator.popAndPushNamed(context, '/motoasignado');
                  }*/
                                    },
                                  ),
                                  ElevatedButton(
                                    child: const Text('Ya fue Entregado?'),
                                    onPressed: () {
                                      if (pedido['estadoid'] == 3) {
// Cambiar el estado del pedido a 'en camino'
                                        pedidosRef
                                            .doc(pedidosAsignados[index].id)
                                            .update({
                                          'estadoid': 4,
                                          'fechaEntrega':
                                              Timestamp.fromDate(now),
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'El pedido ya fue ENTREGADO'),
                                          ),
                                        );
                                        Navigator.pop(context);
                                        setState(() {});
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Ocurrio un error vuelvelo a intentarlo mas tarde o comunicate con el encargado'),
                                          ),
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              ));

                      // Mostrar un mensaje de confirmación

                      AlertDialog(
                        title: const Text('Pedido en camino'),
                        content:
                            Text('Favor dirigite a ${pedido['direccion']}'),
                        actions: [
// Botón de aceptar.
                          ElevatedButton(
                            child: const Text('Aceptar'),
                            onPressed: () {
// Navegar a la pantalla de pedidos creados
                            },
                          ),
                        ],
                      );

                      /*ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pedido en camino'),
                    ),
                  );*/
                    },
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
