import 'package:bandname/pages/home_page.dart';
import 'package:bandname/pages/status_page.dart';
import 'package:bandname/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(  
      providers: [
        ChangeNotifierProvider( create: ( _ ) => SocketService() )
      ],
      child: MaterialApp(
        title: 'BandName',
        initialRoute: 'home',
        routes: {
          'home'   : ( _ ) => HomePage(),
          'status' : ( _ ) => StatusPage(),
        },
      ),
    );
  }
}
