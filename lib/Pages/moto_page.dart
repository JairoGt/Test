import 'package:appseguimiento/Pages/MotoristaPage/moto_asignado.dart';
import 'package:flutter/material.dart';

class MotoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MotoPage(),
                          ),
                        );
      },),
      appBar: AppBar(
        title: Text('Motorista'),
      ),
      body: Center(
        child: Text('Funciones de Motorista'),

        
      ),
    );
  }
}