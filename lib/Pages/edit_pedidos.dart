import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

class EditarPedido extends StatefulWidget {
  const EditarPedido({super.key});

  @override
  State<EditarPedido> createState() => _EditarPedidoState();
}

class _EditarPedidoState extends State<EditarPedido> {
    TextEditingController idPedidoController = TextEditingController();
TextEditingController direccionController = TextEditingController();
  final _precioTotalController= TextEditingController();
 final _firestore = FirebaseFirestore.instance;

  bool _estadoPedido = true;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar pedido'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ID del pedido
                TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                    enabled: _estadoPedido,
                  controller: idPedidoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18)
                    ),
                    labelText: 'ID del pedido',
                  ),
                  
                   onChanged: (value) {
                        value = value.toUpperCase().trim();
                        idPedidoController.text = value;
                      },
      validator: (value) {
          if (value == null || !(value.contains('GT') || value.contains('gt'))) {
        return 'El ID del pedido debe contener "GT"';
          }
          if (value.length < 4){
        return'El tracking es invalido revisa el numero';
          }
          return null;
        },
                      
                ),
                // Botón para buscar el ID del pedido
              ElevatedButton(
                
                
        onPressed: () async {
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
          // Obtiene el ID del pedido del usuario
          final idPedido = idPedidoController.text;
          if(idPedido.isNotEmpty){
         final pedido = await _firestore
                            .collection('pedidos')
                            .doc(idPedido)
                            .get();
        // Obtiene los datos del pedido del documento de Firebase Cloud Firestore
        FirebaseFirestore.instance.collection('pedidos').doc(idPedido).get().then((doc) {
          if (doc.exists) {
             // Verifica si el documento existe
           if(  pedido['estadoid'] < 3){
               setState(() {
              _estadoPedido = false;
            });
            direccionController.text = doc['nombres'];
            _precioTotalController.text = doc['precioTotal'].toString();
             }else{
              showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('El pedido ya se encuentra en camino, No lo podemos actualizar'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        idPedidoController.text = '';                    
                      },
                      child: const Text('OK'),
                    )
                  ],
                );
              },
            );
             }
          
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('El pedido no existe'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        idPedidoController.text = '';                    
                      },
                      child: const Text('OK'),
                    )
                  ],
                );
              },
            );
          }
        });
          } else {
          
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('El número de seguimiento no puede estar vacío'),
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
          }
        },
        child: const Text('Buscar'),
      ),
      
                // Dirección
                TextFormField(
                  controller: direccionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18)
                    ),
                    labelText: 'Pedido',
                  ),
                ),
                // Precio total
                const SizedBox(
                  height: 30.0,
                ),
                TextFormField(
      
                  keyboardType: TextInputType.number,
                  controller: _precioTotalController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18)
                    ),
                    labelText: 'Precio total',
                  ),
                ),
                // Botón de actualizar
                ElevatedButton(
        onPressed: () {
          // Obtiene los datos actualizados
          final direccionActualizada = direccionController.text;
          final precioTotalActualizado = double.tryParse(_precioTotalController.text);
      
          // Verifica si los campos están vacíos
          if (direccionActualizada.isEmpty || precioTotalActualizado == null) {
        print('Los campos no pueden estar vacíos');
        return;
          }
      
          // Crea un mapa con los datos actualizados
          final datosActualizados = {
        'direccion': direccionActualizada,
        'precioTotal': precioTotalActualizado,
          };
      
          // Actualiza el documento
          FirebaseFirestore.instance.collection('pedidos').doc(idPedidoController.text).update(datosActualizados);
      
          // Cierra el diálogo
          Navigator.pop(context);
          showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Actualizacion'),
            content: const Text('Pedido Actualizado con exito'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Gracias'),
              )
            ],
          );
        },
          );
        },
        child: const Text('Actualizar'),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
              _estadoPedido = true;
            });
          idPedidoController.text = '';
          direccionController.text = '';  
          _precioTotalController.text = '';
        },
        child: const Text('Editar otro pedido'),
      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
