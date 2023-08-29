import 'package:appseguimiento/Pages/cliente/cliente2.dart';
import 'package:flutter/material.dart';

class ClientScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       floatingActionButton: FloatingActionButton(onPressed: () {
         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => 
                            ClienteTrack(),
                          ),
                        );
      },),
      appBar: AppBar(
        title: Text('Cliente'),
      ),
      body: Center(
        child: Text('Area del Cliente'),

        
      ),
    );
  }
}