// ignore_for_file: file_names, unused_element

import 'dart:math';

//import 'package:appseguimiento/Pages/asignacion_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
String getGreeting() {
  final currentTime = DateTime.now();
  final hour = currentTime.hour;

  if (hour >= 5 && hour < 12) {
    return 'Buen día';
  } else if (hour >= 12 && hour < 18) {
    return 'Buena tarde';
  } else {
    return 'Buena noche';
  }
}

class CrearPedidoScreen extends StatefulWidget {
  const CrearPedidoScreen({super.key});

  @override
  State<CrearPedidoScreen> createState() => _CrearPedidoScreenState();
}

final now = DateTime.now();

class _CrearPedidoScreenState extends State<CrearPedidoScreen>
    with SingleTickerProviderStateMixin {
  final _nombresController = TextEditingController();
  final _precioTotalController = TextEditingController();
  final _direccionController = TextEditingController();

  // Obtener la hora y fecha del teléfono.
  // Convertir la hora y fecha a un objeto de tipo Timestamp.
  final timestamp = Timestamp.fromDate(now);

  // Declare an animation controller for the text field transitions
  late AnimationController _animationController;

  // Declare an animation for the text field opacity
  late Animation<double> _textFieldOpacityAnimation;

  // Declare a global key that uniquely identifies the Form widget
  final _formKey = GlobalKey<FormState>();

  // Declare a variable to store the button state
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a duration of one second
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Initialize the text field opacity animation with a curve and a range
    _textFieldOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Start the animation when the screen is loaded
    _animationController.forward();
  }

  @override
  void dispose() {
// Dispose the animation controller when the screen is disposed
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// Use MediaQuery to get the size and orientation of the device
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear pedido'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
      // Wrap each text field with a FadeTransition widget to apply the animation
                FadeTransition(
                  opacity: _textFieldOpacityAnimation,
                  child: TextFormField(
                    controller: _nombresController,
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18)
                      ),
                      labelText: 'Nombres de productos',
                    ),
                    onEditingComplete: _actualizarListadoNombres,
      // Define the validator function for the text field
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese al menos un nombre de producto';
                      }
                      if (value.contains(RegExp(r'[^a-zA-Z0-9, ]'))) {
                        return 'Por favor, no use caracteres especiales';
                      }
                      return null;
                    },
      // Define the onChanged function to update the button state
                    onChanged: (value) {
                      setState(() {
                        _isButtonEnabled = _formKey.currentState!.validate();
                      });
                    },
                  ),
                ),
                const SizedBox(
                height: 30.0,
              ),
                FadeTransition(
                  opacity: _textFieldOpacityAnimation,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _precioTotalController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      labelText: 'Precio total',
                    ),
      // Define the validator function for the text field
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese el precio total';
                      }
                      final precio = double.tryParse(value);
                      if (precio == null || precio <= 0) {
                        return 'Por favor, ingrese un número positivo';
                      }
                      if (value.contains(RegExp(r'\.\d{3,}'))) {
                        return 'Por favor, no use más de dos decimales';
                      }
                      return null;
                    },
      // Define the onChanged function to update the button state
                    onChanged: (value) {
                      setState(() {
                        _isButtonEnabled = _formKey.currentState!.validate();
                      });
                    },
                  ),
                ),
                const SizedBox(
                height: 30.0,
              ),
                FadeTransition(
                  opacity: _textFieldOpacityAnimation,
                  child: TextFormField(
                    controller: _direccionController,
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      labelText: 'Dirección de entrega',
                    ),
      // Define the validator function for the text field
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese la dirección de entrega';
                      }
                      if (value.length > 100) {
                        return 'Por favor, ingrese una dirección más corta';
                      }
                      return null;
                    },
      // Define the onChanged function to update the button state
                    onChanged: (value) {
                      setState(() {
                        _isButtonEnabled = _formKey.currentState!.validate();
                      });
                    },
                  ),
                ),
      
      // Use a SizedBox to add some space between the text fields and the button
                SizedBox(height: size.height * 0.05),
      
      // Wrap the button with a FadeTransition widget to apply the animation
                FadeTransition(
                  opacity: _textFieldOpacityAnimation,
                  child: ElevatedButton(
      // Disable the button if any of the text fields is invalid or empty
                    onPressed:
                        _isButtonEnabled ? _crearPedido : null,
                    child: const Text('Crear pedido'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Actualiza el listado de nombres de productos.
  void _actualizarListadoNombres() {
// Obtener los nombres de productos del campo de texto.
    final nombres = _nombresController.text.split(',');

// Actualizar el listado de nombres de productos.
    setState(() {
      _listadoNombres = nombres;
    });
  }
// Añadir un método _mostrarMensajePedidoCreado que muestre un Dialog con el número de pedido generado.

  void _mostrarMensajePedidoCreado(String idPedido) {
// Crear el Dialog.
    final dialog = AlertDialog(
      title: const Text('Pedido creado'),
      content: Text('El número de pedido es: $idPedido'),
      actions: [
// Botón de aceptar.
        ElevatedButton(
          child: const Text('Aceptar'),
          onPressed: () {
// Navegar a la pantalla de pedidos creados.
            _navegarAPedidosCreados();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('El número de pedido es: $idPedido'),
                action: SnackBarAction(
                  label: 'Copiar',
                  onPressed: () {
                    // Copiar el ID del pedido al portapapeles.
                    Clipboard.setData(ClipboardData(text: idPedido));
                  },
                ),
              ),
            );
          },
        ),
      ],
    );

// Mostrar el Dialog.
    showDialog(context: context, builder: (context) => dialog);
  }

  // Crea el pedido.
  void _crearPedido() {
    // Obtener los datos del pedido del usuario.
    final nombres = _nombresController.text;
    final precioTotal = double.parse(_precioTotalController.text);
    final direccion = _direccionController.text;
    final random = Random();

    final idPedido = random.nextInt(10000) + 1;

    final idPedidoFormateado = idPedido.toString().padLeft(3, '0');

    final idPedidoSJP = 'GT$idPedidoFormateado';

    // Crear el pedido en Cloud Firestore.
    FirebaseFirestore.instance.collection('pedidos').doc(idPedidoSJP).set({
      'nombres': nombres,
      'precioTotal': precioTotal,
      'direccion': direccion,
      'estadoid': 1,
      'idMotorista': '0',
      'idpedidos': idPedidoSJP,
      'fechaCreacion': Timestamp.fromDate(now),
      'fechadespacho': Timestamp.fromDate(now),
      'fechaCamino': Timestamp.fromDate(now),
      'fechaEntrega': Timestamp.fromDate(now),
    });
// Mostrar el mensaje emergente con el número de pedido generado.
    _mostrarMensajePedidoCreado(idPedidoSJP);

// Mostrar un mensaje de confirmación.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pedido creado correctamente'),
      ),
    );
  }
// En el método `_navegarAPedidosCreados`, limpiar la pantalla de los campos de generar pedido.

  void _navegarAPedidosCreados() {
    // Limpiar los campos de generar pedido.
    _nombresController.clear();
    _precioTotalController.clear();
    _direccionController.clear();
    Navigator.pop(context);
    // Navegar a la pantalla de pedidos creados.
                    Navigator.popAndPushNamed(context, '/asignacion');

  }
  // Mostrar un mensaje de confirmación.
}

// Listado de nombres de productos.
List<String> _listadoNombres = [];
