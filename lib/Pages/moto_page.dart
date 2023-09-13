import 'package:appseguimiento/Pages/MotoristaPage/moto_asignado.dart';
import 'package:flutter/material.dart';

class MotoScreen extends StatelessWidget {
  const MotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MotoPage(),
                          ),
                        );
      },),
      appBar: AppBar(
        title: const Text('Motorista'),
      ),
      body: const Center(
        child: Text('Funciones de Motorista'),

        
      ),
    );
  }
}