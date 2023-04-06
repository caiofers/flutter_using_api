import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String address = "";
  String street = "";
  String neighborhood = "";
  String city = "";
  String state = "";

  TextEditingController cepController = TextEditingController();

  getCEP() async {
    String cep = cepController.text;
    String url = "https://viacep.com.br/ws/$cep/json/";
    http.Response response;
    response = await http.get(Uri.parse(url));

    try {
      Map<String, dynamic> data = json.decode(response.body);

      if (data["erro"] == true) {
        throw Exception();
      }

      setState(() {
        street = data["logradouro"] ?? "";
        neighborhood = data["bairro"] ?? "";
        city = data["localidade"] ?? "";
        state = data["uf"] ?? "";

        address = "Endereço: $street, $neighborhood, $city - $state";
      });
    } catch (e) {
      setState(() {
        address = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consumo de API")),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(children: [
          TextField(
            decoration: const InputDecoration(labelText: "CEP"),
            controller: cepController,
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(onPressed: getCEP, child: const Text("Clique")),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(address),
                  ],
                )),
          )
        ]),
      ),
    );
  }
}
