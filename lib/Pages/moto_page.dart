// ignore_for_file: use_build_context_synchronously

import 'package:appseguimiento/Pages/MotoristaPage/moto_asignado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';

showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: SpinKitSpinningLines(
            color: Colors.blue,
            size: 50.0,
          ),
        ),
      );
    },
  );
}

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

class MotoScreen extends StatefulWidget {
  const MotoScreen({super.key});

  @override
  State<MotoScreen> createState() => _MotoScreenState();
}

class _MotoScreenState extends State<MotoScreen> 
with SingleTickerProviderStateMixin {
  late User userLocal;
  final greeting = getGreeting();
  final user = FirebaseAuth.instance.currentUser;
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
    });

    // Obtener el ID del motorista
    _idMotorista = auth.currentUser!.email.toString();

    // Obtener pedidos asignados
    pedidosRef
        .where('idMotorista', isEqualTo: _idMotorista)
        .where('estadoid', isNotEqualTo: 4)
        .snapshots()
        .listen((snapshot) {
      pedidosAsignados = snapshot.docs;
      setState(() {}); // Actualizar la interfaz de usuario
    });
  }

  @override
  Widget build(BuildContext context) {
    final numPedidos = pedidosAsignados.length;
    return Scaffold(
   appBar: AppBar(
        title: Text(
          greeting,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Text(
                  user!.displayName ?? '${user!.email}',
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () async {
              try {
                showLoadingDialog(context);
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser!.providerData.any((userInfo) => userInfo.providerId == 'google.com')) {
                  // User is signed in with Google
                  await GoogleSignIn().signOut();
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                } else {
                  showLoadingDialog(context);
                  // User is signed in with email and password
                  await FirebaseAuth.instance.signOut();
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }
              } catch (e) {
                print("Error al cerrar sesión: $e");
              }
            },
            icon: const Icon(Icons.login),
            color: Colors.red,
          ),
        ],
      ),
      body: WillPopScope(
         onWillPop: () async => false,
           child:  Center(
             child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     
                  children: <Widget>[
                    numPedidos == 0
      ? Text('No tienes pedidos asignados', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
      : Column(
          children: [
            Text('Tienes la cantidad de: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            Text('$numPedidos pedidos asignados', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
          ],
        ),
                  ],
                     
                   ),
           )
          
        ),
      
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        Navigator.push(
                          context,
                         CupertinoPageRoute(
                            builder: (_) => const AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: MotoPage(),
                            ),
                          ),
                        );

                        
        },
        child: const Icon(Icons.motorcycle_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}