import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// Mapeo de los IDs de estado a sus nombres
const estados: { [key: number]: string } = {
    1: 'Pendiente',
    2: 'En proceso',
    3: 'En camino',
    4: 'Entregado',
    // Agrega aquí los demás estados según necesites
};

exports.notificarCambioEstado = functions.firestore
    .document('pedidos/{idpedidos}')
    .onUpdate(async (change, context) => {
        const pedidoAnterior = change.before.data();
        const pedidoActual = change.after.data();

        // Verificar si el estado del pedido ha cambiado
        if (pedidoAnterior.estadoid !== pedidoActual.estadoid) {
            // Obtener el ID del pedido y el nuevo estado
            
            const pedidoId = context.params.idpedidos;
            const nuevoEstadoId = pedidoActual.estadoid;
            const nuevoEstadoNombre = estados[nuevoEstadoId];

            // Crear la notificación
            const mensaje = {
                notification: {
                    title: `El estado de tu pedido ${pedidoId} ha cambiado`,
                    body: `Tu pedido ha sido marcado como ${nuevoEstadoNombre}`
                },
                topic: `pedido_${pedidoId}`  // Asegúrate de que los usuarios se suscriban a este tema
            };

            // Enviar la notificación
            try {
                await admin.messaging().send(mensaje);
                console.log(`Notificación enviada para el pedido ${pedidoId}`);
            } catch (error) {
                console.error(`Error al enviar la notificación para el pedido ${pedidoId}:`, error);
            }
        }
    });
