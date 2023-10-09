// ignore_for_file: use_build_context_synchronously


import 'package:appseguimiento/Pages/cliente/cliente2.dart';
import 'package:appseguimiento/auth/login.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
//import 'package:appseguimiento/Pages/cliente/cliente2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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


class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();

}

class _ClientScreenState extends State<ClientScreen> 
  with SingleTickerProviderStateMixin {
  late User userLocal;
  final greeting = getGreeting();
  final user = FirebaseAuth.instance.currentUser;

  int _selectedIndex = 0; // Índice del ítem seleccionado

void _onItemTapped(int index) async {
  setState(() {
    _selectedIndex = index; // Actualiza el ítem seleccionado
  });

  switch (index) {
    case 0:
      // Tu código aquí
      
      break;
    case 1:
      Navigator.push(
        context,
        CupertinoPageRoute(
                        builder: (_) => const AnimatedSwitcher(
                          duration: Duration(milliseconds: 200),
                          child: ClienteTrack(),
                        ),
                      ),
      );
      break;
    
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          greeting,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          
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
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
          const Text('Bienvenido ', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          Text(
                  user!.displayName ?? '${user!.email}',
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
            Center(
              child: Image.asset(
              'images/animated.png',
              frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
            ),
            
            ),
            const Text('Para hacere el seguimiento de tu pedido selecciona  SEGUIMIENTO', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
          ],
        )
       ,

      ),
       bottomNavigationBar: ConvexAppBar(
          style: TabStyle.react,
          backgroundColor: Colors.black,
          gradient: const LinearGradient(
            colors: [Colors.orange, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
    items: const [
      TabItem(icon: Icons.home, title: 'Inicio'),
      TabItem(icon: Icons.spatial_tracking, title: 'Seguimiento',),
      
      //TabItem(icon: Icons.home, title: 'Inicio'),
    ],
     initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
  ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     //print(_idPedido);

      //     Navigator.push(
      //       context,
      //       CupertinoPageRoute(
      //                       builder: (_) => const AnimatedSwitcher(
      //                         duration: Duration(milliseconds: 200),
      //                         child: ClienteTrack(),
      //                       ),
      //                     ),
      //     );
      //   },
      //   child: const Icon(Icons.assignment_sharp),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

