// ignore_for_file: use_build_context_synchronously

import 'package:appseguimiento/Pages/MotoristaPage/moto_asignado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MotoScreen extends StatelessWidget {
  const MotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      appBar:  AppBar(
      forceMaterialTransparency: false,
        
        toolbarHeight: 89,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(greeting,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        flexibleSpace: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            
            children: [
              SizedBox(height: 10,),
              Padding(
                
                padding: const EdgeInsets.all(0),
                
                child: Text(
                  user!.displayName ?? '${user!.email}',
                  style: const TextStyle(fontSize: 26, color: Colors.grey),
                ),
              ),
              
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    
    Navigator.popUntil(context, ModalRoute.withName('/'));
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
        child: const Center(
          child: Text('Para '),
          
          
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        Navigator.push(
                          context,
                         CupertinoPageRoute(
                            builder: (_) => const AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: MotoPage(),
                            ),
                          ),
                        );
        },
        child: const Icon(Icons.assignment_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}