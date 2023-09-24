// ignore_for_file: use_build_context_synchronously

import 'package:appseguimiento/Pages/MotoristaPage/moto_asignado.dart';
import 'package:appseguimiento/Pages/cliente/cliente2.dart';
//import 'package:appseguimiento/Pages/cliente/cliente2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
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
                  user!.displayName ?? '${user!.email}',
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
                try {
    await FirebaseAuth.instance.signOut();
    
    Navigator.popUntil(context, ModalRoute.withName('/'));
    Navigator.popAndPushNamed(context, '/login');
  } catch (e) {
   // print("Error al cerrar sesión: $e");
  }
              },
              icon: const Icon(Icons.login),
              color: Colors.red,
              )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child:const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
      
        
        child: Text(
          'Presiona el boton para ver el progreso de tu pedido\nrecuerda tener a la mano tu numero de seguimiento',
          style: TextStyle(fontSize: 20),
        ),
          ),
        ],


      ),
      ),
       bottomNavigationBar: BottomAppBar(
        elevation: 1,
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //print(_idPedido);

          Navigator.push(
            context,
            CupertinoPageRoute(
                            builder: (_) => const AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: ClienteTrack(),
                            ),
                          ),
          );
        },
        child: const Icon(Icons.assignment_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

