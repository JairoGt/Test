// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:appseguimiento/Pages/asignacion_page.dart';
import 'package:appseguimiento/Pages/edit_pedidos.dart';
import 'package:appseguimiento/Pages/list_page.dart';
import 'package:appseguimiento/Pages/pedidosScreen.dart';
import 'package:appseguimiento/Pages/role_page.dart';
//import 'package:appseguimiento/auth/login.dart';
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

// ignore: must_be_immutable
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late User userLocal;
  final greeting = getGreeting();
  
  // Declare an animation controller for the button transitions
  late AnimationController _animationController;

  // Declare an animation for the button offsets


  @override
  void initState() {
    
    super.initState();

    // Initialize the animation controller with a duration of one second
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );


    // Start the animation when the screen is loaded
    _animationController.forward();
  }

  @override
  void dispose() {
    // Dispose the animation controller when the screen is disposed
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        
        child: Center(
          
          child: Column(
        children: [
          
         const SizedBox(height: 40),
          Expanded(
            flex: 1,
            child: GridView.count(
               childAspectRatio: 0.9,
              mainAxisSpacing: 30.0,
              crossAxisSpacing: 15,
              crossAxisCount: 2,
              children: [
                
                
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 200,
                  height: 200,
                  child: ElevatedButton(
                    child: const Text('Asignar Rol'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RolePage(),
                        ),
                      );
                    },
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 200,
                  height: 200,
                  child: ElevatedButton(
                    child: const Text('Listado de Pedidos'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PedidosPage(),
                        ),
                      );
                    },
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 200,
                  height: 200,
                  child: ElevatedButton(
                    child: const Text('Generar Pedido'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CrearPedidoScreen(),
                        ),
                      );
                    },
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 200,
                  height: 200,
                  child: ElevatedButton(
                    child: const Text('Asignar de Motorista'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AsignarPedidos(),
                        ),
                      );
                    },
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 200,
                  height: 200,
                  child: ElevatedButton(
                    child: const Text('Modificar Pedido'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  EditarPedido(),
                        ),
                      );
                    },
                  ),
                ),

              
              ],
              
            ),
          ),
        ],
          ),
          
        ),
      ),
      
      );
    
  }
}
