import 'dart:io';

import 'package:bandname/models/band.dart';
import 'package:bandname/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [];

  void _activeBands( dynamic payload ) {

    this.bands = ( payload as List )
      .map(( band ) => Band.fromMap( band ))
      .toList();

      setState(() { });
  }

  @override
  void initState() {
    
    final provider = Provider.of<SocketService>( context, listen: false );
    provider.socket.on('active-bands', _activeBands );

    super.initState();
  }


  @override
  void dispose() {
   
    final provider = Provider.of<SocketService>( context, listen: false );
    provider.socket.off( 'active-bads' );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final provider = Provider.of<SocketService>( context );

    return Scaffold(
      appBar: AppBar(
        title: Text(" BandApp", style: TextStyle( color: Colors.black87 )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        actions: [
          Container(
            margin: const EdgeInsets.only( right: 8.0 ),
            child: provider.serverStatus == ServerStatus.Online
              ? Icon( Icons.check_circle, color: Colors.green[300] )
              : Icon( Icons.offline_bolt, color: Colors.red[300] )
          )
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),
        elevation: 1.0,
        onPressed: _onPressFab,
      ),
    );
  }
  

  Widget _buildBody() {

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200.0,
          child: this.bands.isEmpty
            ? Center( child: CircularProgressIndicator() )
            : _drawChart()
        ),
        Expanded(
          child: ListView.builder( 
            itemCount: bands.length,
            itemBuilder: ( context, i) => _buildItem( bands[i] )
          )
        ),
      ],
    );
  }

  Widget _drawChart() {

    Map<String, double> dataMap = {
      // "Flutter": 5,
      // "React": 3,
      // "Xamarin": 2,
      // "Ionic": 2,
     };

  
    this.bands.forEach( ( band ) => dataMap[band.name] = band.votes.toDouble() );

    List<Color> colorList= [
      Colors.amber[300],
      Colors.blue[200],
      Colors.red[200],
      Colors.pink[100],
      Colors.purple[100],
      Colors.green[100],
      Colors.indigo[100],
      Colors.lime[100]
    ];

    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 20,
      //centerText: "HYBRID",
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
      ),
    );
  }
      
  Widget _buildItem( Band band ) {

    final provider = Provider.of<SocketService>( context, listen: false );

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
        onTap: () => provider.socket.emit( 'vote-band', { 'id' : band.id } )
        ,
      ),
      onDismissed: ( _ ) {
        provider.socket.emit('delete-band', { 'id': band.id });
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

    final provider = Provider.of<SocketService>( context, listen: false );

    provider.socket.emit('add-band', { 'name': value });
    // setState(() {
    //   this.bands.add( Band(id: DateTime.now().toString(), name: value, votes: 0 ));
    // });

    Navigator.of(context).pop();
  }
}