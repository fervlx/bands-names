import 'dart:io';

import 'package:bandname/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band( id: '1', name: 'La Renga', votes: 10 ),
    Band( id: '2', name: 'Los Piojos', votes: 8 ),
    Band( id: '3', name: 'Ataque 77', votes: 7 ),
    Band( id: '4', name: 'Guasones', votes: 5 ),
    Band( id: '5', name: 'Carajo', votes: 6 ),
  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(" BandApp", style: TextStyle( color: Colors.black87 )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: ListView.builder( 
        itemCount: bands.length,
        itemBuilder: ( context, i) => _buildItem( bands[i] )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),
        elevation: 1.0,
        onPressed: _onPressFab,
      ),
    );
  }
      
  Widget _buildItem(Band band) {

    return Dismissible(
      key: Key( band.id ),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: const EdgeInsets.symmetric( horizontal: 16.0 ),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon( Icons.delete, color: Colors.white ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text( band.name.substring( 0,2 )),
          backgroundColor: Colors.blue[100],
        ),
        title: Text( band.name ),
        trailing: Text( '${band.votes}', style: TextStyle( fontSize: 20.0 )),
        onTap: () {
          print( band.name );
        },
      ),
      onDismissed: ( direction ) {
        print( direction );
      },
    );
  }

  void _onPressFab() {

    final textController = TextEditingController();

    if ( Platform.isAndroid ) {

      showDialog(
        context :  context,
        builder : ( _ ) {
          return AlertDialog(
            title: Text('Nueva banda'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                child: Text("Agregar"),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => _onPressAddDialog( textController.text ),
              )
            ],
          );
        }
      );

      return;
    }

    showCupertinoDialog(
      context: context, 
      builder: ( _ ) {
        return CupertinoAlertDialog(
          title: Text( 'Nueva banda' ),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Agregar"),
              onPressed: () => _onPressAddDialog( textController.text ),
            ),
            CupertinoDialogAction(   //  se agrega porque no desaparece solo el dialogo cuando se toca en cualquier parte.
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      }
    );
  }

  void _onPressAddDialog( String value ) {

    if ( value.length < 1 ) {
      print("empty field");
      return; 
    }

    setState(() {
      this.bands.add( Band(id: DateTime.now().toString(), name: value, votes: 0 ));
    });

    Navigator.of(context).pop();
  }
}