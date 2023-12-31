// ignore_for_file: use_build_context_synchronously

import 'package:appseguimiento/Pages/cliente/history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../MotoristaPage/moto_asignado.dart';

class ClienteTrack extends StatefulWidget {
  const ClienteTrack({super.key});

  @override
  State<ClienteTrack> createState() => _ClienteTrackState();
}

class _ClienteTrackState extends State<ClienteTrack> {
  final _firestore = FirebaseFirestore.instance;
  late User userLocal;
  final _trackingNumberController = TextEditingController();
  String _trackingNumber = '';
  String _texto1 = '';
  String _texto2 = '';
  int currentState = 0;
  bool _isButtonEnabled = false;
  final _formKey = GlobalKey<FormState>();
  final _trackingNumberFocusNode = FocusNode();

  var _circle1 = AnimatedContainer(
    duration: const Duration(seconds: 1),
    curve: Curves.easeInOut,
    width: 100,
    height: 100,
    child: const Icon(Icons.check_circle, color: Colors.green),
  );

  Color clamp(int value, int min, int max) {
    return Color(value.clamp(min, max));
  }

  void _onEditingComplete() {
    _onTrackingNumberChanged();
    _trackingNumberFocusNode.unfocus();
  }

  onStepTapped(int value) {
    setState(() {
      currentState = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _trackingNumberController.addListener(_onTrackingNumberChanged);
  }

  @override
  void dispose() {
    _trackingNumberController.dispose();
    _trackingNumberFocusNode.dispose();
    super.dispose();
  }

  void _onTrackingNumberChanged() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
      _trackingNumber = _trackingNumberController.text
          .toUpperCase()
          .trim()
          .replaceAll(' ', '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _onTrackingNumberChanged();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Seguimiento de pedidos'),
          actions: [
            IconButton(
              // Hacer un refresh de la página
              onPressed: () {
                setState(() {
                  _trackingNumberController.clear();
                  _trackingNumber = '';
                  _texto1 = '';
                  _texto2 = '';
                  _circle1 = AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    width: 100,
                    height: 100,
                    child: const Icon(Icons.check_circle, color: Colors.green),
                  );
                });
              },
              icon: const Icon(
                Icons.refresh_outlined,
                color: Colors.green,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.popAndPushNamed(context, '/tracking');
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => const AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: PedidosH(),
                ),
              ),
            );
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.history),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _trackingNumberController,
                      focusNode: _trackingNumberFocusNode,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18)),
                        labelText: 'ID del pedido',
                      ),
                      onChanged: (value) {
                        setState(() {
                          value =
                              value.toUpperCase().trim().replaceAll(' ', '');
                          _trackingNumber = value;
                          _onTrackingNumberChanged();
                        });
                      },
                      onEditingComplete: _onEditingComplete,
                      validator: (value) {
                        if (value == null ||
                            !(value.contains('GT') || value.contains('gt'))) {
                          return 'El ID del pedido debe contener "GT"';
                        }
                        if (value.length < 4) {
                          return 'El tracking es invalido revisa el numero';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _circle1,
                  ],
                ),
                const SizedBox(height: 4),

                // Código para consultar el pedido y mostrar el estado
                ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () async {
                          if (_trackingNumber.isNotEmpty) {
                            final pedido = await _firestore
                                .collection('pedidos')
                                .doc(_trackingNumber)
                                .get();

                            if (pedido.exists) {
                              _texto1 = '';
                              _texto2 = '';

                              final estados =
                                  pedido['estadoid'].toString().split(',');

                              // Itera sobre los estados de los pedidos y establece el estado actual del Stepper.
                              for (int i = 0; i < estados.length; i++) {
                                setState(() {});
                              }
                              for (final estado in estados) {
                                setState(() {
                                  _circle1 = AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInOut,
                                    width: MediaQuery.of(context).size.width,
                                    height: 400,
                                    child: Stepper(
                                      onStepTapped: onStepTapped,
                                      controlsBuilder: (BuildContext context,
                                          ControlsDetails details) {
                                        return const Row(
                                          children: <Widget>[],
                                        );
                                      },
                                      currentStep: int.parse(estado) - 1,
                                      steps: [
                                        Step(
                                          state: int.parse(estado) >= 1
                                              ? StepState.complete
                                              : StepState.disabled,
                                          isActive: int.parse(estado) >= 1,
                                          title: const Text('Creado'),
                                          subtitle: Text(
                                              'Tu pedido fue creado el ${DateFormat('d/M/y').format(pedido['fechaCreacion'].toDate())}\n alas ${DateFormat('HH:mm').format(pedido['fechaCreacion'].toDate())}'),
                                          content: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  getIcon(pedido['estadoid']
                                                          .toString())
                                                      .icon,
                                                  color: Colors.green,
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Step(
                                          state: int.parse(estado) >= 2
                                              ? StepState.complete
                                              : StepState.disabled,
                                          isActive: int.parse(estado) >= 2,
                                          title: const Text('En Proceso'),
                                          subtitle: Visibility(
                                            visible: int.parse(estado) >= 2
                                                ? true
                                                : false,
                                            child: Text(
                                                'Ya fue Despachado el ${DateFormat('d/M/y').format(pedido['fechadespacho'].toDate())}\n alas ${DateFormat('HH:mm').format(pedido['fechadespacho'].toDate())}'),
                                          ),
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                getIcon(pedido['estadoid']
                                                        .toString())
                                                    .icon,
                                                color: Colors.amberAccent,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Step(
                                          state: int.parse(estado) >= 3
                                              ? StepState.complete
                                              : StepState.disabled,
                                          isActive: int.parse(estado) >= 3,
                                          title: const Text('En Camino'),
                                          subtitle: Visibility(
                                            visible: int.parse(estado) >= 3
                                                ? true
                                                : false,
                                            child: Text(
                                                'Tu pedido salio a las ${DateFormat('HH:mm').format(pedido['fechaCamino'].toDate())} \n el ${DateFormat('d/M/y').format(pedido['fechaCamino'].toDate())}'),
                                          ),
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    getIcon(pedido['estadoid']
                                                            .toString())
                                                        .icon,
                                                    color: Colors.deepOrange,
                                                    size: 50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Step(
                                          state: int.parse(estado) >= 4
                                              ? StepState.complete
                                              : StepState.disabled,
                                          isActive: int.parse(estado) >= 4,
                                          title: const Text('Entregado'),
                                          subtitle: Visibility(
                                            visible: int.parse(estado) >= 4
                                                ? true
                                                : false,
                                            child: Text(
                                                'Pedido entregado el ${DateFormat('d/M/y').format(pedido['fechaEntrega'].toDate())}\n alas ${DateFormat('HH:mm').format(pedido['fechaEntrega'].toDate())}'),
                                          ),
                                          content: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  // Oculta los iconos que no están en el estado actual.
                                });

                                // Muestra el contenido del pedido.
                                _texto1 += (pedido['nombres'].toString());

                                // Muestra la cantidad que tiene que pagar el cliente.
                                _texto2 +=
                                    // ignore: unnecessary_string_escapes
                                    (pedido['precioTotal'].toString());
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text('El Pedido no existe'),
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
                              ); // Muestra un mensaje de error.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('El pedido no existe'),
                                ),
                              );
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  // ignore: prefer_const_constructors
                                  content: Text(
                                      'El número de seguimiento no puede estar vacío'),
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
                        }
                      : null,
                  child: const Text('Consultar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_trackingNumber.isNotEmpty) {
                      String? token =
                          await FirebaseMessaging.instance.getToken();

                      FirebaseFirestore.instance
                          .collection('tokens')
                          .doc(token)
                          .set({
                        'token': token,
                        'tema': 'pedido_$_trackingNumber',
                      });
                      FirebaseFirestore.instance
                          .collection('pedidos')
                          .doc(_trackingNumber)
                          .update({
                        'idcliente': '${user!.email}',
                      });
                      // Registra el pedido para recibir notificaciones
                      await FirebaseMessaging.instance
                          .subscribeToTopic('pedido_$_trackingNumber');

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Activado'),
                            // ignore: prefer_const_constructors
                            content:
                                Text('Te has suscrito a las notificaciones'),
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
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            // ignore: prefer_const_constructors
                            content: Text(
                                'El número de seguimiento no puede estar vacío'),
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
                  child: const Text('Activar Notificaciones'),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 100.0,
          notchMargin: 4.5,
          shape: const CircularNotchedRectangle(),
          child: Container(
              height: 20.0,
              padding: const EdgeInsets.only(top: 20.0),
              child: _texto1.isEmpty && _texto2.isEmpty
                  ? Text(
                      '            ↓ Aquí aparecerá el detalle de tu pedido',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      'Tus productos son: $_texto1 y el total a pagar es Q$_texto2',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      ),
    );
  }

  Color getColor(String estado) {
    switch (estado) {
      case '1':
        return Colors.green;
      case '2':
        return Colors.yellow;
      case '3':
        return Colors.orange;
      case '4':
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }

  Icon getIcon(String estado) {
    switch (estado) {
      case '1':
        return const Icon(
          Icons.check_circle,
          color: Colors.grey,
          size: 110,
        );
      case '2':
        return const Icon(
          Icons.hourglass_bottom,
          color: Colors.amberAccent,
          fill: 1,
          size: 110,
        );
      case '3':
        return const Icon(
          Icons.delivery_dining,
          color: Colors.orange,
          size: 110,
        );
      case '4':
        return const Icon(
          Icons.check_box,
          color: Colors.green,
          size: 110,
        );
      default:
        return const Icon(Icons.error, color: Colors.transparent);
    }
  }

  String getNombreEstado(String estado) {
    switch (estado) {
      case '1':
        return 'Despachado';
      case '2':
        return 'En proceso';
      case '3':
        return 'En Camino';
      case '4':
        return 'Entregado';
      default:
        return 'No disponible';
    }
  }
}
