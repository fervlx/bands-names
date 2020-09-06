import 'package:bandname/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BandName',
      initialRoute: 'home',
      routes: {
        'home' : ( context ) => HomePage(),
      },
    );
  }
}
