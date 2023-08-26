import 'package:appseguimiento/Pages/list_page.dart';
import 'package:appseguimiento/Pages/pedidosScreen.dart';
import 'package:appseguimiento/Pages/role_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

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

class _AdminScreenState extends State<AdminScreen> {
final LocalAuthentication authentication = LocalAuthentication();

  final bool _useFingerprint = false;
final user = FirebaseAuth.instance.currentUser;

  final greeting = getGreeting();
  

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
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.login))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 200,
                    height: 200,
                    child: ElevatedButton(
                      child: Text('Asignar Rol'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RolePage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 200,
                    height: 200,
                    child: ElevatedButton(
                      child: Text('Generar Pedido'),
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CrearPedidoScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 200,
                    height: 200,
                    child: ElevatedButton(
                      child: Text('Listado de pedidos'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PedidosPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 200,
                    height: 200,
                    child: ElevatedButton(
                      child: Text('Button 4'),
                      onPressed: () async {
                        final bool isAvailable = await authentication.canCheckBiometrics;
if (isAvailable && _useFingerprint) {
  final bool success = await authentication.authenticate(
      localizedReason: 'Inicia sesión con tu huella digital');
  if (success) {
    // El usuario se autentica con huella digital
  } else {
    // La huella digital no fue reconocida
  }
}
                      },
                    ),
                  ),
                ),
              
              ],
            ),
          ],
        ),
      ),
    );
  }
}