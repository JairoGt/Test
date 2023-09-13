

import 'package:appseguimiento/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

 registration() async {
try {
// ignore: unused_local_variable
UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
email: mailcontroller.text,
password: passwordcontroller.text,
);

  //Si se loguea correctamente, lo redirecciona a la pantalla de inicio
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Login()),
  );
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.orangeAccent,
      content: Text(
        'La contraseña es muy debil',
        style: TextStyle(fontSize: 18.0),
      ),
    ));
  } else if (e.code == "email-already-in-use") {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.orangeAccent,
      content: Text(
        'El correo ya existe',
        style: TextStyle(fontSize: 18.0),
      ),
    ));
  }
}
//final FirebaseAuth auth = FirebaseAuth.instance;
// Obtiene el documento del usuario en la colección `users` con el correo electrónico especificado.
FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference users = firestore.collection('users');
DocumentReference userDocument = users.doc(mailcontroller.text);
Map<String, dynamic> data = {
  'name': namecontroller.text,
  'email': mailcontroller.text.trim(),
  'idmoto': '0',
  'role': 'client',
  
};

userDocument.set(data);

// Obtiene el valor del campo `role`.
DocumentSnapshot snapshot = await userDocument.get();

// Si el valor del campo `role` es `null`, entonces el usuario no tiene un rol asignado, por lo que lo asignamos como cliente.
if (snapshot.exists) {
  var role = snapshot['role'];

  if (mounted) {
    if (role == null) {
      userDocument.update({'role': 'client'});
    }
  }
}
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141E5A),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                "images/design.jpg",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.5,
                fit: BoxFit.cover,
              ),
                    const Text(
                      "Hola...!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36.0,
                          fontFamily: 'Pacifico'),
                    ),
                  const  SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                          color: const Color(0xFF4c59a5),
                          borderRadius: BorderRadius.circular(30)),
                      child: TextFormField(
                        controller: namecontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Porfavor ingresa un nombre';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.person_2_outlined,
                              color: Colors.white,
                            ),
                            hintText: 'Tu nombre',
                             
                        errorStyle: TextStyle(
        color: Colors.red,
        fontSize: 16.0,
        textBaseline: TextBaseline.alphabetic,
        fontWeight: FontWeight.bold,
      ),
                            hintStyle: TextStyle(color: Colors.white60)),
                        style:  const TextStyle(color: Colors.white),
                      ),
                    ),
                   const  SizedBox(
                      height: 30.0,
                    ),
                   Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      color: const Color(0xFF4c59a5),
                      borderRadius: BorderRadius.circular(22)),
                  child: TextFormField(
                    controller:  mailcontroller,
                    validator: (value){
                      if(value==null|| value.isEmpty){
                         return 'Porfavor, Ingresa tu Correo';
              
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        hintText: 'Ingresa tu correo',
                        
                        errorStyle: TextStyle(
        color: Colors.red,
        fontSize: 16.0,
        textBaseline: TextBaseline.alphabetic,
        fontWeight: FontWeight.bold,
      )
      
      ,
                        hintStyle: TextStyle(color: Colors.white60),
                        
                        ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
                   const SizedBox(
                      height: 30.0,
                    ), Container(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    color: const Color(0xFF4c59a5),
                    borderRadius: BorderRadius.circular(22)),
                child: TextFormField(
                     controller: passwordcontroller,
                  validator: (value){
                    if(value==null|| value.isEmpty){
                      return 'Porfavor Ingresa tu contraseña';

                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.white,
                      ),
                      hintText: 'Password',
                      errorStyle: TextStyle(
        color: Colors.red,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
                      hintStyle: TextStyle(color: Colors.white60)),
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                ),
              ),
                    const SizedBox(
                      height: 80.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                          
                            email = mailcontroller.text;
                            name = namecontroller.text;
                            password = passwordcontroller.text;
                          });
                        }
                        registration();
                      },
                      child: Center(
                        child: Container(
                          width: 150,
                          height: 55,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: const Color(0xFFf95f3b),
                              borderRadius: BorderRadius.circular(30)),
                          child:const Center(
                              child: Text(
                            "Crear Cuenta",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
              ),
              Row(
                children: [
                 
                 const Spacer(),
                  const Text(
                    "Ya tienes cuenta?",
                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Login()));
                      },
                      child:const Text(
                        " Inicia sesion",
                        style: TextStyle(
                            color: Color(0xFFf95f3b),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      )),
                 const Spacer(),
                  
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}