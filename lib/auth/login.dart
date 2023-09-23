// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison
import 'package:appseguimiento/Pages/admin_page.dart';
import 'package:appseguimiento/Pages/client_page.dart';
import 'package:appseguimiento/Pages/moto_page.dart';
import 'package:appseguimiento/auth/forgotpassword.dart';
import 'package:appseguimiento/auth/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
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

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

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

  String email = "";
  String password = "";
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
                content: const Text(
                    'You are not authorized to access the application.'),
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


  @override
  Widget build(BuildContext context) {
    Future<UserCredential?> signInWithGoogle() async {
      // Initialize GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Trigger the sign-in flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential? userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential != null) {
         showLoadingDialog(context);
        // Get the user's email
        final String email = userCredential.user!.email!;
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference users = firestore.collection('users');

        // Get the document for the current user
        DocumentReference userDocument = users.doc(email);

        // Try to get the document for the current user
        DocumentSnapshot snapshot = await userDocument.get();

        if (snapshot.exists) {
         
          var role = snapshot['role'];
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
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Unauthorized'),
                content: const Text(
                    'You are not authorized to access the application.'),
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
        } else {
          // If the document does not exist, create it with the role of 'client'
          userDocument.set({
            'name': userCredential.user!.displayName,
            'email': email,
            'idmoto': '0',
            'role': 'client',
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClientScreen(),
            ),
          );
        }
      }
  
      return userCredential;
    }
    //TextFormField para el correo electrónico
    var textFormField = TextFormField(
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors
                              .white // Si el tema es oscuro, usa texto blanco
                          : Colors
                              .white, // Si el tema es claro, usa texto negro
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next, // Agregado
                    controller: useremailcontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        labelText: 'Correo Electrónico',
                        prefixIcon: const Icon(Icons.email)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese la dirección de correo electrónico';
                      }
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
                    onChanged: (value) {
                      setState(() {
                        _isButtonEnabled = _formkey.currentState!.validate();
                      });
                    },
                  );
   //TextFormField para la contraseña
    var textFormField2 = TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white // Si el tema es oscuro, usa texto blanco
                        : Colors.white, // Si el tema es claro, usa texto negro
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  controller: userpasswordcontroller,
                  obscureText: true,
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.password)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese la contraseña';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _isButtonEnabled = _formkey.currentState!.validate();
                    });
                  },
                );
    
    return Scaffold(
      backgroundColor: const Color(0xFF141E5A),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Image.asset(
                "images/above1.jpg",
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 5,
                fit: BoxFit.cover,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "Bienvenido de Nuevo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: 'Avenir',
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: textFormField,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: textFormField2,
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
                child: ElevatedButton(
                  onPressed: () {
                    if (_isButtonEnabled) {
                      userLogin();
                    }
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        email = useremailcontroller.text;
                        password = userpasswordcontroller.text;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFf95f3b),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text(
                    "Iniciar Sesión",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "¿Nuevo usuario?",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                    child: const Text(
                      " Regístrate",
                      style: TextStyle(
                          color: Color(0xFFf95f3b),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        color:const Color(0xFF141E5A),
        shape: const CircularNotchedRectangle(),
        child: Container(height: 100.0
        ,
          padding: const EdgeInsets.only(top: 20.0),
          child: const Text('Iniciar Sesión con Google',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white 
            : Colors.blueAccent,
        onPressed: () async {
          //print(_idPedido);

          try {
            await signInWithGoogle();
          } on FirebaseException {
            //print('Error: $e');
          }
        },
        child: Image.asset(
          'images/google.png',
          width: 50.0,
          height: 50.0,
          fit: BoxFit.cover,
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
