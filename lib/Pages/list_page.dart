// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:appseguimiento/Pages/providers/pedidos_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_scroll/cross_scroll.dart';
import 'dart:io';

import 'package:printing/printing.dart';



final pedidosProvider = PedidosProvider();

class PedidosPage extends StatelessWidget {
  const PedidosPage({Key? key});

  int _compareFechas(
      DocumentSnapshot<Object?> a, DocumentSnapshot<Object?> b) {
    return b['fechaCreacion']!.toDate().millisecondsSinceEpoch -
        a['fechaCreacion']!.toDate().millisecondsSinceEpoch;
  }



  Future<void> generatePDF(BuildContext context, List<DocumentSnapshot<Object?>> data) async {
   
   final pdf = pw.Document();
final pedidos = await pedidosProvider.getPedidos();
pedidos.sort(_compareFechas);


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
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title:const Text('Éxito'),
              content: const Text('PDF guardado en la carpeta de Descargas'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                  },
                  child:const Text('OK'),
                ),
              ],
            );
          },
        );
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
      // Manejar el caso en el que la
}
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, '/asignacion');
          
        },
        icon: const Icon(Icons.arrow_back),
      ),
      centerTitle: true,
      
      actions: [
        IconButton(
          onPressed: () async {
            final pedidos = await pedidosProvider.getPedidos();
            generatePDF(context, pedidos);
          },
          icon: const Icon(Icons.picture_as_pdf),
        )
      ],
      title: const Text('Pedidos'),
    ),
    body: FutureBuilder<List<DocumentSnapshot>>(
      future: pedidosProvider.getPedidos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final pedidos = snapshot.data!;
          pedidos.sort(_compareFechas);

          return CrossScroll(
            child: SizedBox(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Tracking')),
                  DataColumn(label: Text('Dirección')),
                  DataColumn(label: Text('Estado')),
                  DataColumn(label: Text('Total a pagar')),
                  DataColumn(label: Text('Fecha de Pedido')),
                ],
                rows: pedidos
                    .map(
                      (pedido) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              pedido['idpedidos'].toString(),
                              style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(Text(pedido['direccion'])),
                          DataCell(
                            pedido['estadoid'] == 1
                                ? const Text('(CREADO)', style: TextStyle(color: Colors.green))
                                : pedido['estadoid'] == 2
                                    ? const Text('(DESPACHADO)', style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold))
                                    : pedido['estadoid'] == 3
                                        ? const Text('(EN CAMINO)', style: TextStyle(color: Colors.orange))
                                        : pedido['estadoid'] == 4
                                            ? const Text('(ENTREGADO)', style: TextStyle(color: Colors.red))
                                            : const Text(''),
                          ),
                          DataCell(Text('Q${pedido['precioTotal']}')),
                          DataCell(Text(DateFormat('d/M/y').format(pedido['fechaCreacion'].toDate()))),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error!.toString()),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
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
                                'Aqui podras ver todos los pedidos que se han realizado, puedes ver el estado de cada uno de ellos, y tambien puedes generar un PDF con todos los pedidos que se han realizado hasta el momento'),
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