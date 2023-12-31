// Importamos las bibliotecas necesarias
// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, iterable_contains_unrelated_type
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Inicializamos Cloud Firestore
final firebaseFirestore = FirebaseFirestore.instance.collection('pedidos');
final now = DateTime.now();
// Colección de pedidos
final pedidosRef = FirebaseFirestore.instance.collection('pedidos');

final motoristasRef = FirebaseFirestore.instance.collection('users');

// Clase principal de la aplicación
class ReasignarPedidos extends StatefulWidget {
  const ReasignarPedidos({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReasignarPedidosState createState() => _ReasignarPedidosState();
}

// Estado de la aplicación
class _ReasignarPedidosState extends State<ReasignarPedidos> {
  Timer? _timer;
  // Importamos las bibliotecas necesarias

// Estado de la aplicación

  // Lista de pedidos
  List<DocumentSnapshot> pedidos = [];

  // Lista de motoristas
  List<DocumentSnapshot> motoristas = [];

  // ID del pedido seleccionado
  late String _idPedido = '0';

  // ID del motorista seleccionado
  late String _idMotorista = '0';

  final timestamp = Timestamp.fromDate(now);

  @override
  void initState() {
    super.initState();

    // Obtener pedidos
    pedidosRef.where('estadoid', isEqualTo: 2).snapshots().listen((snapshot) {
      pedidos = snapshot.docs;

      setState(() {});
    });

    // Obtener motoristas
    motoristasRef.snapshots().listen((snapshot) {
      motoristas = snapshot.docs;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignar pedidos'),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'SELECCIONA UN PEDIDO',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    borderOnForeground: true,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      physics: const ClampingScrollPhysics(),
                      itemCount: pedidos.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(
                            pedidos[index]['idpedidos'] +
                                ' \n Entrega en: ' +
                                pedidos[index]['direccion'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(pedidos[index]['nombres']),
                          value: _idPedido == pedidos[index].id,
                          onChanged: (value) {
                            _idPedido = value! ? pedidos[index].id : '';
                            _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Actualiza el estado del widget
        });
      } else {
        // Cancela el temporizador si el widget ya no está en el árbol de widgets
        _timer?.cancel();
      }
    });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),

              const Text(
                'SELECCIONA AL MOTORISTA ',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
              // Lista de motoristas
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          borderOnForeground: true,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: motoristasRef
                                .where('role', isEqualTo: 'moto')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      // height: 50,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      child: CheckboxListTile(
                                        title: Text(
                                          snapshot.data!.docs[index]['name'],
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(snapshot
                                            .data!.docs[index]['idmoto']),
                                        value: _idMotorista ==
                                            snapshot.data!.docs[index]['email'],
                                        onChanged: (value) {
                                          // Actualiza el valor de _idMotorista
                                          _idMotorista = value!
                                              ? snapshot.data!.docs[index]
                                                  ['email']
                                              : '';
                                          // Actualiza el widget
                                          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Actualiza el estado del widget
        });
      } else {
        // Cancela el temporizador si el widget ya no está en el árbol de widgets
        _timer?.cancel();
      }
    });
                                        },
                                      ),
                                    );
                                  },
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  primary: false,
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    
      bottomNavigationBar: BottomAppBar(
        
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? Colors.green  // Si el tema es oscuro, usa texto blanco
        : Colors.blueAccent, 
        onPressed: () async {
          //print(_idPedido);

          try {
           
// Mostrar un mensaje de error
            if (_idPedido == '0' || _idMotorista == '0') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('No se ha seleccionado ningún Motorista o Pedido'),
                ),
              );
              return;
            } else {
              try {
                await pedidosRef.doc(_idPedido).update({
                  'idMotorista': _idMotorista,
                  'estadoid': 2,
                  'fechadespacho': Timestamp.fromDate(now),
                });
             
              _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Actualiza el estado del widget
        });
      } else {
        // Cancela el temporizador si el widget ya no está en el árbol de widgets
        _timer?.cancel();
      }
    });

// Navegar a otra página
                Navigator.popAndPushNamed(context, '/listaPedidos');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
// ignore: prefer_interpolation_to_compose_strings
                    content: Text('Pedido Asignado'),
                  ),
                );
              } catch (e) {
               
                // Mostrar un mensaje de error
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
// ignore: prefer_interpolation_to_compose_strings
                    content: Text('Alerta estas dejando un campo vacio  '),
                  ),
                );

                 _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Actualiza el estado del widget
        });
      } else {
        // Cancela el temporizador si el widget ya no está en el árbol de widgets
        _timer?.cancel();
      }
    });
                 Navigator.popAndPushNamed(context, '/asignacion');
              }
            }
          } on FirebaseException {
             _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Actualiza el estado del widget
        });
      } else {
        // Cancela el temporizador si el widget ya no está en el árbol de widgets
        _timer?.cancel();
      }
    });
            Navigator.popAndPushNamed(context, '/asignacion');

// Mostrar un mensaje de error
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Error no has seleccionado el Pedido o al motorista asegurate de seleccionar a los 2 '),
              ),
            );
          }
        },
        child: const Icon(Icons.assignment_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
