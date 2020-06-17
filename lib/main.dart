import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=de53d777";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.amber,
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)))),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final kwanzaController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final realController = TextEditingController();

  double dolar;
  double euro;
  double akz;
  double real;

  void _clearAll() {
    kwanzaController.text = "";
    dolarController.text = "";
    euroController.text = "";
    realController.text = "";
  }


  void _kwanzaChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double kz = double.parse(text);
    //realController.text = ().toStringAsFixed(2);
    //euroController.text = ().toStringAsFixed(2);
    //dolarController.text = ().toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    //kwanzaController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    //kwanzaController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    //kwanzaController.text = (euro * this.euro).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor de Moedas \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "A carregar dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Erro ao carregar dados :(",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    //akz = snapshot.data["results"]["currencies"]["AOA"]["buy"];
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.amber),
                          buildeTextField("Kwanza", "AOA\$",kwanzaController, _kwanzaChanged),
                          Divider(),
                          buildeTextField("Dólares", "US\$", dolarController,
                              _dolarChanged),
                          Divider(),
                          buildeTextField(
                              "Euros", "€\$", euroController, _euroChanged),
                          Divider(),
                          buildeTextField(
                              "Real", "R\$", realController, _realChanged)
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildeTextField(String label, String prefix,
    TextEditingController controller, Function function) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    keyboardType: TextInputType.number,
    onChanged: function,
  );
}
