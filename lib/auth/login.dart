// ignore_for_file: use_build_context_synchronously
import 'package:appseguimiento/Pages/admin_page.dart';
import 'package:appseguimiento/Pages/client_page.dart';
import 'package:appseguimiento/Pages/moto_page.dart';
import 'package:appseguimiento/auth/forgotpassword.dart';
import 'package:appseguimiento/auth/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/material.dart';

showLoadingDialog(BuildContext context) {
  showDialog(
    
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          
          child: SpinKitSpinningCircle(
            color: Colors
                .blue, // Cambia el color de la animación según tus preferencias
            size: 50.0, // Tamaño de la animación
          ),
        ),
      );
    },
  );
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late AnimationController animationController;
  late TickerProvider vsync;
  _LoginState() {
    // vsync = this;
  }

  @override
  void initState() {
    super.initState();
    vsync = this;
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: vsync,
    );
  }

  String email = "", password = "";
  final _formkey = GlobalKey<FormState>();

  bool _isButtonEnabled = false;
  final bool autofocus = false;
  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  userLogin() async {
    try {
      showLoadingDialog(context);

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('users');
      DocumentReference userDocument = users.doc(useremailcontroller.text);

      DocumentSnapshot snapshot = await userDocument.get();

      if (snapshot.exists) {
        var role = snapshot['role'];

        if (mounted) {
          if (role == 'admin') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminScreen(),
              ),
            );
          } else if (role == 'moto') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MotoScreen(),
              ),
            );
          } else if (role == 'client') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ClientScreen(),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Unauthorized'),
                content:
                    const Text('You are not authorized to access the application.'),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          }
        }
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Unauthorized'),
              content: const Text('The user does not exist.'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Tu usuario no existe",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ));
        }
      } else if (e.code == 'wrong-password') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            "Error en Contraseña",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          )));
        }
      }
      Navigator.pop(context);
    }
  }

  Color? _getColorTween() {
    return ColorTween(
      begin: Colors.deepOrange,
      end: Colors.white,
    )
        .animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeInExpo,
          ),
        )
        .value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141E5A),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "images/above1.jpg",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.9,
                fit: BoxFit.cover,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "Bienvenido de\nNuevo",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 34.0,
                      fontFamily: 'Pacifico'),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: useremailcontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      labelText: 'Correo Electronico',
                    ),
                    // Define the validator function for the text field
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese la dirección de correo electrónico';
                      }
                      // Utiliza una expresión regular para validar el formato del correo electrónico
                      final emailRegExp =
                          RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Por favor, ingrese un correo electrónico válido';
                      }
                      if (value.length > 100) {
                        return 'Por favor, ingrese una dirección de correo más corta';
                      }
                      return null;
                    },
                    // Define the onChanged function to update the button state
                    onChanged: (value) {
                      setState(() {
                        _isButtonEnabled = _formkey.currentState!.validate();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: userpasswordcontroller,
                  obscureText: true,

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    labelText: 'Contraseña',
                  ),
                  // Define the validator function for the text field
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese la contraseña';
                    }
                    return null;
                  },
                  // Define the onChanged function to update the button state
                  onChanged: (value) {
                    setState(() {
                      _isButtonEnabled = _formkey.currentState!.validate();
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassword()));
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 24.0),
                  alignment: Alignment.bottomRight,
                  child: const Text(
                    "Olvidaste tu contraseña?",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Center(
                child: FilledButton.tonalIcon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        _getColorTween(),
                      ),
                      minimumSize:
                          const MaterialStatePropertyAll(Size(200, 70)),
                      maximumSize:
                          const MaterialStatePropertyAll(Size(300, 100)),
                      animationDuration: Durations.long1,
                      foregroundColor:
                          const MaterialStatePropertyAll(Colors.white),
                      textStyle: const MaterialStatePropertyAll(
                        TextStyle(
                            fontSize: 20,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      ),
                      iconColor: const MaterialStatePropertyAll(Colors
                          .white) // La propiedad `initialColor` define el color del fondo del botón antes de que se presione.
                      ),
                  label: const Text('Iniciar sesion'),
                  icon: const Icon(Icons.start),
                  onPressed: () {
                    _isButtonEnabled ? userLogin() : null;

                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        email = useremailcontroller.text;
                        password = userpasswordcontroller.text;
                      });
                    }

                    userLogin();
                  },
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Nuevo Usuario?",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const SignUp()));
                      },
                      child: const Text(
                        " Registrate",
                        style: TextStyle(
                            color: Color(0xFFf95f3b),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}