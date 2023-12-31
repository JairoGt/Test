
// ignore_for_file: use_build_context_synchronously

import 'package:appseguimiento/auth/login.dart';
import 'package:appseguimiento/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  TextEditingController mailcontroller =  TextEditingController();

    final _formkey= GlobalKey<FormState>();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Correo Enviado, favor de revisar su buzon !",
        style: TextStyle(fontSize: 18.0),
      )));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Porfavor, Verificar su correo.",
          style: TextStyle(fontSize: 18.0),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(133, 60, 8, 8),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 50.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              const SizedBox(
                height: 70.0,
              ),
              Container(
                alignment: Alignment.topCenter,
                child: const Text(
                  "Recuperar Contraseña",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                "Ingresa tu correo",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    child: ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white70, width: 2.0),
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            controller: mailcontroller,
                            validator: (value){
                              if(value==null || value.isEmpty){
                                return 'Es necesario Ingresa tu correo registrado';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Corre Electronico",
                                errorStyle: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
                                hintStyle: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.white70,
                                  size: 30.0,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                       const SizedBox(height: 40.0),
                        Container(
                          margin: const EdgeInsets.only(left: 60.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if(_formkey.currentState!.validate()){
                                    setState(() {
                                      email= mailcontroller.text;
                                    });
                                    resetPassword();
                                    
                                  }
                                },
                                child: Container(
                                    width: 140,
                                    padding:const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 184, 166, 6),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: const Center(
                                      child: Text(
                                        "Enviar",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                       CupertinoPageRoute(
                            builder: (_) => const AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: Login(),
                            ),
                          ),
                                      (route) => false);
                                },
                                child: Container(
                                    alignment: Alignment.bottomRight,
                                    child: const Text(
                                      "Inicia sesion",
                                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "No Estas Registrado? ",
                              style:
                                  TextStyle(fontSize: 18.0, color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                            builder: (_) => const AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: SignUp(),
                            ),
                          ),
                                        );
                              },
                              child: const Text("Crear Cuenta",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 184, 166, 6),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}