// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:appseguimiento/Pages/MotoristaPage/reasignacion.dart';
import 'package:appseguimiento/Pages/asignacion_page.dart';
import 'package:appseguimiento/Pages/edit_pedidos.dart';
import 'package:appseguimiento/Pages/list_page.dart';
import 'package:appseguimiento/Pages/pedidosScreen.dart';
import 'package:appseguimiento/Pages/role_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

//Saludo de acuerdo a la hora del día
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
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late User userLocal;
  final greeting = getGreeting();

  // Declare an animation controller for the button transitions
  late AnimationController _animationController;

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
                padding: const EdgeInsets.all(10),
                child: Text(
  user!.displayName ?? '${user.email}',
  style: TextStyle(
    fontSize: user.displayName != null ? 18 : 10,
    color: Colors.grey,
  ),
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
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                flex: 1,
                child: GridView.count(
                  childAspectRatio: 1.9,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 100,
                      height: 100,
                      child: ElevatedButton(
                        child: const Text('Asignar Rol'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const AnimatedSwitcher(
                                duration: Duration(milliseconds: 200),
                                child: RolePage(),
                              ),
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
                            CupertinoPageRoute(
                              builder: (_) => const AnimatedSwitcher(
                                duration: Duration(milliseconds: 200),
                                child: PedidosPage(),
                              ),
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
                            CupertinoPageRoute(
                              builder: (_) => const AnimatedSwitcher(
                                duration: Duration(milliseconds: 200),
                                child: CrearPedidoScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 100,
                      height: 100,
                      child: ElevatedButton(
                        child: const Text('Asignar de Motorista'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const AnimatedSwitcher(
                                duration: Duration(milliseconds: 200),
                                child: AsignarPedidos(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 100,
                      height: 100,
                      child: ElevatedButton(
                        child: const Text('Modificar Pedido'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const AnimatedSwitcher(
                                duration: Duration(milliseconds: 200),
                                child: EditarPedido(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 100,
                      height: 100,
                      child: ElevatedButton(
                        child: const Text('ReAsignar Pedido'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const AnimatedSwitcher(
                                duration: Duration(milliseconds: 200),
                                child: ReasignarPedidos(),
                              ),
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.green
            : Colors.blueAccent,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Ayuda'),
                content: const Text(
                    'Aquí podrás ver las funciones que puedes realizar como administrador, puedes asignar roles, ver el listado de pedidos, generar un pedido, asignar un pedido a un motorista y modificar un pedido'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  )
                ],
              );
            },
          );
        },
        child: const Icon(Icons.help),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}