//import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:appseguimiento/Pages/providers/pedidos_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'dart:io';

import 'package:printing/printing.dart';

final pedidosProvider = PedidosProvider();

class PedidosPage extends StatefulWidget {
  const PedidosPage({Key? key});

  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  int _compareFechas(
      DocumentSnapshot<Object?> a, DocumentSnapshot<Object?> b) {
    return b['fechaCreacion']!.toDate().millisecondsSinceEpoch -
        a['fechaCreacion']!.toDate().millisecondsSinceEpoch;
  }

  Future<void> generatePDF(
    BuildContext context, List<DocumentSnapshot<Object?>> data) async {
  final pdf = pw.Document();

  // Filtrar los pedidos según las fechas seleccionadas
  final pedidos = data.where((pedido) {
  final fechaCreacion = pedido['fechaCreacion'].toDate();
  return (_fechaInicio == null || fechaCreacion.isAfter(_fechaInicio!)) &&
         (_fechaFin == null || fechaCreacion.isBefore(_fechaFin!.add(Duration(days: 1)))) &&
         (_fechaInicio != null || _fechaFin != null || fechaCreacion.isAtSameMomentAs(_fechaFin!));
});

  // Sumar el precio total de los pedidos entregados
  final totalEntregado = pedidos.fold<double>(0, (total, pedido) {
    if (pedido['estadoid'] == 4) {
      return total + pedido['precioTotal'];
    } else {
      return total;
    }
  });

  pdf.addPage(
    pw.MultiPage(
      build: (context) {
        return [
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
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.IntrinsicColumnWidth(),
              1: pw.IntrinsicColumnWidth(),
              2: pw.IntrinsicColumnWidth(),
              3: pw.IntrinsicColumnWidth(),
              4: pw.IntrinsicColumnWidth(),
            },
            children: <pw.TableRow>[
              pw.TableRow(
                children: <pw.Widget>[
                  pw.Text('Tracking '),
                  pw.Text('Dirección'),
                  pw.Text('Estado'),
                  pw.Text('Total a pagar'),
                  pw.Text('Fecha de Pedido'),
                ],
              ),
              ...pedidos.map((pedido) => pw.TableRow(
                    children: <pw.Widget>[
                      pw.Text(pedido['idpedidos'].toString()),
                      pw.Text(pedido['direccion'] ?? ''),
                      pw.Text(pedido['estadoid'] == 1
                          ? ' CREADO '
                          : pedido['estadoid'] == 2
                              ? ' DESPACHADO '
                              : pedido['estadoid'] == 3
                                  ? ' EN CAMINO '
                                  : pedido['estadoid'] == 4
                                      ? ' ENTREGADO '
                                      : ''),
                      pw.Text('Q${pedido['precioTotal']}'),
                      pw.Text(DateFormat('d/M/y')
                          .format(pedido['fechaCreacion'].toDate())),
                    ],
                  )),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text('Total entregado: Q$totalEntregado'),
        ];
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
            title: const Text('Éxito'),
            content: const Text('PDF guardado en la carpeta de Descargas'),
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

  int _selectedIndex = 0; // Índice del ítem seleccionado

void _onItemTapped(int index) async {
  setState(() {
    _selectedIndex = index; // Actualiza el ítem seleccionado
  });

  switch (index) {
    case 0:
      // Tu código aquí
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aqui podras ver todos los pedidos que se han realizado, puedes ver el estado de cada uno de ellos, y tambien puedes generar un PDF con todos los pedidos que se han realizado hasta el momento\n'),

        ),
      );
      break;
    case 1:
      final fecha = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
      );
      if (fecha != null) {
        setState(() {
          _fechaInicio = fecha;
        });
      }
      break;
    case 2:
      final fecha = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
      );
      if (fecha != null) {
        setState(() {
          _fechaFin = fecha;
        });
      }
      break;
    case 3:
      setState(() {
        _fechaInicio = null;
        _fechaFin = null;
      });
      break;
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
          //SizedBox(height: 100,width: 100,);
          if (snapshot.hasData) {
            final pedidos = snapshot.data!;
            pedidos.sort(_compareFechas);

            // Filtrar los pedidos según las fechas seleccionadas 2
     if (_fechaInicio != null && _fechaFin != null) {
  pedidos.retainWhere((pedido) {
    final fechaCreacion = pedido['fechaCreacion'].toDate();
    return fechaCreacion.isAtSameMomentAs(_fechaInicio!) ||
        fechaCreacion.isAfter(_fechaInicio!) &&
        fechaCreacion.isBefore(_fechaFin!.add(Duration(days: 1)));
  });
}

            final totalEntregado = pedidos.fold<double>(0, (total, pedido) {
              if (pedido['estadoid'] == 4) {
                return total + pedido['precioTotal'];
              } else {
                return total;
              }
            });

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView
              
              (
              scrollDirection: Axis.horizontal,    
                  
                  
                    
             child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Tracking')),
                            DataColumn(label: Text('Dirección')),
                            DataColumn(label: Text('Estado')),
                            DataColumn(label: Text('Total a pagar')),
                            DataColumn(label: Text('Fecha de Pedido')),
                          ],
                          rows: [
                            ...pedidos.map((pedido) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        pedido['idpedidos'].toString(),
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataCell(Text(pedido['direccion'] ?? '')),
                                    DataCell(pedido['estadoid'] == 1
                                        ? const Text('(CREADO)',
                                            style: TextStyle(color: Colors.green))
                                        : pedido['estadoid'] == 2
                                            ? const Text('(DESPACHADO)',
                                                style: TextStyle(
                                                    color: Colors.yellow,
                                                    fontWeight: FontWeight.bold))
                                            : pedido['estadoid'] == 3
                                                ? const Text('(EN CAMINO)',
                                                    style: TextStyle(
                                                        color: Colors.orange))
                                                : pedido['estadoid'] == 4
                                                    ? const Text('(ENTREGADO)',
                                                        style: TextStyle(
                                                            color: Colors.red))
                                                    : const Text('')),
                                    DataCell(
                                        Text('Q${pedido['precioTotal']}')),
                                    DataCell(Text(DateFormat('d/M/y').format(
                                        pedido['fechaCreacion'].toDate()))),
                                  ],
                                )),
                            DataRow(
                              cells: [
                                const DataCell(Text('')),
                                const DataCell(Text('')),
                                const DataCell(Text('')),
                                DataCell(
                                    Text(
                                        'Total de pedidos Entregados: ----> Q$totalEntregado',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))),
                                const DataCell(Text('')),
                              ],
                            ),
                          ],
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
     

        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.react,
          backgroundColor: Colors.black,
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
    items: const [
      TabItem(icon: Icons.help, title: 'Ayuda'),
      TabItem(icon: Icons.calendar_today, title: 'Fecha Inicio',),
      TabItem(icon: Icons.date_range, title: 'Fecha Fin'),
      TabItem(icon: Icons.refresh, title: 'Limpiar'),
      //TabItem(icon: Icons.home, title: 'Inicio'),
    ],
    initialActiveIndex: _selectedIndex,//optional, default as 0
    onTap: _onItemTapped,
  ),
  /*bottomNavigationBar: BottomNavyBar(
    showElevation: true,
    selectedIndex: _selectedIndex,
    onItemSelected: (index) {
      setState(() {
        _selectedIndex = index;
        _onItemTapped(_selectedIndex);
      });
    },
    items: [
      BottomNavyBarItem(
        icon: Icon(Icons.help),
        title: Text('Ayuda'),
        activeColor: Colors.red,
      ),
      BottomNavyBarItem(
        icon: Icon(Icons.calendar_today),
        title: Text('Fecha Inicio'),
        activeColor: Colors.purpleAccent,
      ),
      BottomNavyBarItem(
        icon: Icon(Icons.date_range),
        title: Text('Fecha Fin'),
        activeColor: Colors.pink,
      ),
      BottomNavyBarItem(
        icon: Icon(Icons.refresh),
        title: Text('Limpiar'),
        activeColor: Colors.blue,
      ),
    ],
  ),

*/
        
        
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}


