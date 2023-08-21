import 'package:flutter/material.dart';


//Cambiar estado con StatefulWidget nos siver para saber por ejemplo el nombre de la persona logeada
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int clickCounter = 0;


  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child:  Text("Hola hola")),
        ),
        body:  Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$clickCounter', style: const TextStyle(fontSize: 160,fontWeight: FontWeight.w100),),
           const Text("Clicks", style: TextStyle(fontSize: 25),)
          ],
          ),
          
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
                //saqui redibujamos el widget y acciona la accion del boton para que vaya aumentando el numero
                setState(() {
                  clickCounter ++;
                });
            },
            child: const Icon(Icons.plus_one),
          ),
      ),
    );
  }
}