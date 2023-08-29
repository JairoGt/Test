// ignore_for_file: use_build_context_synchronously
import 'package:appseguimiento/Pages/admin_page.dart';
import 'package:appseguimiento/Pages/client_page.dart';
import 'package:appseguimiento/Pages/moto_page.dart';
import 'package:appseguimiento/auth/forgotpassword.dart';
import 'package:appseguimiento/auth/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
  
}

class _LoginState extends State<Login>with TickerProviderStateMixin {
  
late AnimationController animationController;
late TickerProvider vsync;
_LoginState() {
   // vsync = this;
   
  }

 @override
  void initState() {
    
    super.initState();
     vsync =this;
     animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: vsync,
    );
    
    
  }

  String email = "", password = "";
  
  final _formkey= GlobalKey<FormState>();

  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  userLogin() async {
    try {
     
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
                builder: (context) => AdminScreen(),
              ),
            );
          } else if (role == 'moto') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MotoScreen(),
              ),
            );
          } else if (role == 'client') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClientScreen(),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Unauthorized'),
                content: Text('You are not authorized to access the application.'),
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
          }
        }
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Unauthorized'),
              content: Text('The user does not exist.'),
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
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:Text(
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
    }
  }
Color? _getColorTween() {
    return ColorTween(
      begin: Colors.deepOrange,
      end: Colors.white,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInExpo,
      ),
    ).value;
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
                  decoration: BoxDecoration(
                      color: const Color(0xFF4c59a5),
                      borderRadius: BorderRadius.circular(22)),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller:  useremailcontroller,
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
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    color: const Color(0xFF4c59a5),
                    borderRadius: BorderRadius.circular(22)),
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                     controller: userpasswordcontroller,
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
                height: 15.0,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword()));
                },
                child: Container(
                  padding: EdgeInsets.only(right: 24.0),
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
              minimumSize: const MaterialStatePropertyAll(Size(200,70)),
              maximumSize: const MaterialStatePropertyAll(Size(300,100)),
            animationDuration: Durations.long1,
          foregroundColor: MaterialStatePropertyAll(
            Colors.white
          ),
            textStyle: const MaterialStatePropertyAll(
              TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold
                
              ),
              
            ),
            
              iconColor: MaterialStatePropertyAll(
                Colors.white
              )// La propiedad `initialColor` define el color del fondo del botón antes de que se presione.
),
  
  label: Text('Iniciar sesion'),
  icon: Icon(Icons.start),
  onPressed: () {
    if(_formkey.currentState!.validate()){
      setState(() {
        email= useremailcontroller.text;
        password= userpasswordcontroller.text;
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
                            MaterialPageRoute(builder: (context) => SignUp()));
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
