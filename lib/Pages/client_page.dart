import 'package:flutter/material.dart';

class ClientScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cliente'),
      ),
      body: Center(
        child: Text('Area del Cliente'),
      ),
    );
  }
}