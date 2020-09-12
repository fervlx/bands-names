import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bandname/services/socket_service.dart';

class StatusPage extends StatelessWidget {

  const StatusPage({Key key}) : super(key: key);

  @override
  Widget build( BuildContext context ) {

    final socketService = Provider.of<SocketService>( context );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text( "Estado del servidor: ${socketService.serverStatus}")
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.message ),
        elevation: 1.0,
        onPressed: () {
          socketService.socket.emit('emitMessage', {
            'nombre'  : 'fernando',
            'message' : 'mensaje de prueba',
          });
        }
      ),
    );
  }
}