// ignore_for_file: use_build_context_synchronously

import 'package:appseguimiento/Pages/MotoristaPage/moto_asignado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MotoScreen extends StatelessWidget {
  const MotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      appBar:  AppBar(
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
                  '${user!.email}',
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
    print("Error al cerrar sesión: $e");
  }
              },
              icon: const Icon(Icons.login),
              color: Colors.red,
              )
        ],
      ),
      body: WillPopScope(
         onWillPop: () async => false,
        child: const Center(
          child: Text('Funciones de Motorista'),
          
          
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MotoPage(),
                          ),
                        );
        },
        child: const Icon(Icons.assignment_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}