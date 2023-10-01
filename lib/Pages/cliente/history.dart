import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;


class PedidosProvider {
  Future<List<DocumentSnapshot>> getPedidos(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('pedidos')
        .where('idcliente', isEqualTo: email)
        .get();
    return querySnapshot.docs;
  }
}

final pedidosRef = FirebaseFirestore.instance.collection('pedidos');
final motoristasRef = FirebaseFirestore.instance.collection('users');

class PedidosH extends StatefulWidget {
  const PedidosH({super.key});

  @override
  State<PedidosH> createState() => _PedidosHState();

  
}

class _PedidosHState extends State<PedidosH> {
  
  List<DocumentSnapshot> pedidosAsignados = [];

  List<DocumentSnapshot> motoristas = [];

  // ID del motorista
  late String _idcliente = '0';

  final FirebaseAuth auth = FirebaseAuth.instance;

  final PedidosProvider pedidosProvider = PedidosProvider();

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    // Obtener motoristas
    motoristasRef.snapshots().listen((snapshot) {
      motoristas = snapshot.docs;

      setState(() {});
    });
    // Obtener el ID del motorista

    _idcliente = auth.currentUser!.email.toString();

    // Obtener pedidos asimoognados
    pedidosRef
        .where('idcliente', isEqualTo: _idcliente)
        .snapshots()
        .listen((snapshot) {
      pedidosAsignados = snapshot.docs;

      setState(() {});
    });

    
  }

  Future<void> generatePDF(BuildContext context, List<DocumentSnapshot<Object?>> data) async {
   
   final pdf = pw.Document();
final pedidos = await pedidosProvider.getPedidos(_idcliente);



pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              child: pw.Paragraph(
                text: '   Lista de pedidos      ',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(),
              ),
            ),
          pw.TableHelper.fromTextArray(
              context: context,
              data: <List<String>>[
                // Encabezados de la tabla
                ['Tracking', 'Dirección', 'Estado', 'Total a pagar', 'Fecha de Pedido'],
                // Datos de los pedidos
                ...pedidos.map((pedido) => [
                  pedido['idpedidos'].toString(),
                  pedido['direccion'] ?? '',
                  pedido['estadoid'] == 1
                      ? '(CREADO)'
                      : pedido['estadoid'] == 2
                          ? '(DESPACHADO)'
                          : pedido['estadoid'] == 3
                              ? '(EN CAMINO)'
                              : pedido['estadoid'] == 4
                                  ? '(ENTREGADO)'
                                  : '',
                  'Q${pedido['precioTotal']}',
                  DateFormat('d/M/y').format(pedido['fechaCreacion'].toDate()),
                ]),
              ],
              
            ),
          ],
        );
      },
    ),
  );

final bytes = await pdf.save();

await Printing.sharePdf(bytes: bytes);
   
    // Obtener la ubicación de la carpeta de almacenamiento externo compartido
    final externalDir = await getExternalStorageDirectory();

    if (externalDir != null) {
      final pdfFile = File('${externalDir.path}/archivo.pdf');

      // Guardar el PDF en la carpeta de almacenamiento externo compartido
      await pdfFile.writeAsBytes(bytes);

      // Verificar si el archivo se ha guardado correctamente
      if (await pdfFile.exists()) {
        
        // Mostrar un cuadro de diálogo de éxito
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: const Text('Éxito'),
          content: const Text('PDF guardado correctamente'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
              child: const Text('OK'),
            ),
          ],
        );
      },);
      } else {
        // Mostrar un cuadro de diálogo de error
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Error al guardar el PDF'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Mostrar un cuadro de diálogo de error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Error al guardar el PDF'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
}
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       actions: [
          IconButton(onPressed: (){
            generatePDF(context, pedidosAsignados);
          }, icon: const Icon(Icons.picture_as_pdf_outlined))
        ],
    
        title: Text('Historial de pedidos',
            style: TextStyle(
                color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Lista de pedidos asignados
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: pedidosAsignados.length,
                itemBuilder: (context, index) {
                  final pedido = pedidosAsignados[index];
                  return InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Text(
                                pedido['idpedidos'].toString(),
                                
                                style: const TextStyle(fontSize: 20),
                                
                              ),
                              onLongPress: (){
                                final clipboardData = ClipboardData(text: pedido['idpedidos'].toString());
              Clipboard.setData(clipboardData);
                              },
                            ),
                          ),
                          Expanded(
                            child: Text(pedido['nombres'] ??
                                'No disponible'), 
                          ),
                          Expanded(
                            child: Text(
                              'Q${pedido['precioTotal'] ?? 'No disponible'}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              DateFormat('d/M/y').format(pedido['fechaCreacion'].toDate()), // Proporciona un valor predeterminado si el campo no existe
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
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
                // ignore: prefer_const_constructors
                content: Text(
                    'Aqui podras ver los pedidos que has realizado, puedes ver el estado de cada uno de ellos, y tambien puedes generar un PDF con todos los pedidos que has realizado hasta el momento (proximamente)'),
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
        child: const Icon(Icons.help_outline_sharp),
      ),
    );
  }
}
