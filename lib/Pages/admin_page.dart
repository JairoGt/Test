import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

class AdminScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
   final greeting = getGreeting();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         centerTitle: true,
         title: Text(greeting, style: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold)),
        flexibleSpace: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            '${user!.email}'
            ,
            style: const TextStyle(fontSize: 16,color: Colors.grey),
          ),
              ),
              // Agregar más widgets aquí
            ],
          ),
        ),
       
        
        actions: [
          IconButton(onPressed: ()async{
            await FirebaseAuth.instance.signOut();
          }, icon: const Icon(Icons.login))
        ],
        
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Convertir a Motorista'),
                      onPressed: () {
                       showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Proximamente'),
              content: Text('Esperalo'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
                      },
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Generar Pedido'),
                      onPressed: () {
                       showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Proximamente'),
              content: Text('Esperalo'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Listado de pedidos'),
                      onPressed: () {
                       showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Proximamente'),
              content: Text('Esperalo'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
                      },
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Button 4'),
                      onPressed: () {
                        print('Button 4 pressed');
                      },
                    ),
                  ),
                ],
              ),
             
            ],
          ),
        ),
      ),
    );
    
    
    
  
  }
  }
