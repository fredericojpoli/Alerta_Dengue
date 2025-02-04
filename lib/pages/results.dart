import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Results extends StatelessWidget {
  dynamic doenca;
  final dynamic geocode;
  dynamic cidade;
  final dynamic data_inicial;
  final dynamic data_final;
  final dynamic startEstimatedCases;
  final dynamic startCases;
  final dynamic startLevel;
  final dynamic startTempMin;
  final dynamic startTempMax;
  final dynamic endEstimatedCases;
  final dynamic endCases;
  final dynamic endLevel;
  final dynamic endTempMin;
  final dynamic endTempMax;

  final Map<String, String> capitaisBrasil = {
    'Aracaju (SE)': '2800308',
    'Belém (PA)': '1501402',
    'Belo Horizonte (MG)': '3106200',
    'Boa Vista (RR)': '1400100',
    'Brasília (DF)': '5300108',
    'Campo Grande (MS)': '5002704',
    'Cuiabá (MT)': '5103403',
    'Curitiba (PR)': '4106902',
    'Florianópolis (SC)': '4205407',
    'Fortaleza (CE)': '2304400',
    'Goiânia (GO)': '5208707',
    'João Pessoa (PB)': '2507507',
    'Macapá (AP)': '1600303',
    'Maceió (AL)': '2704302',
    'Manaus (AM)': '1302603',
    'Natal (RN)': '2408102',
    'Palmas (TO)': '1721000',
    'Porto Alegre (RS)': '4314902',
    'Porto Velho (RO)': '1100205',
    'Recife (PE)': '2611606',
    'Rio Branco (AC)': '1200401',
    'Rio de Janeiro (RJ)': '3304557',
    'Salvador (BA)': '2927408',
    'São Luís (MA)': '2111300',
    'São Paulo (SP)': '3550308',
    'Teresina (PI)': '2211001',
    'Vitória (ES)': '3205309',
  };

  Results({
    Key? key,
    required this.doenca,
    required this.geocode,
    required this.data_inicial,
    required this.data_final,
    required this.startEstimatedCases,
    required this.startCases,
    required this.startLevel,
    required this.startTempMin,
    required this.startTempMax,
    required this.endEstimatedCases,
    required this.endCases,
    required this.endLevel,
    required this.endTempMin,
    required this.endTempMax,
  }) : super(key: key) {
    cidade = descobreCidade(geocode);
    doenca = capitalize(doenca);
  }

  String descobreCidade(String geocode) {
    String cidade_encontrada = '';
    capitaisBrasil.forEach((key, value) {
      if (value == geocode) {
        cidade_encontrada = key;
      }
    });
    return cidade_encontrada;
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }
    return string.substring(0, 1).toUpperCase() + string.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alerta Dengue',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resultados:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text('Doença: $doenca'),
            Text('Cidade: $cidade'),
            SizedBox(height: 20),
            Text(
              'Semana Inicial [$data_inicial]:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text('Casos Estimados: $startEstimatedCases'),
            Text('Casos: $startCases'),
            Text('Nível: $startLevel'),
            Text('Temperatura Mínima: $startTempMin'),
            Text('Temperatura Máxima: $startTempMax'),
            SizedBox(height: 20),
            Text(
              'Semana Final [$data_final]:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text('Casos Estimados: $endEstimatedCases'),
            Text('Casos: $endCases'),
            Text('Nível: $endLevel'),
            Text('Temperatura Mínima: $endTempMin'),
            Text('Temperatura Máxima: $endTempMax'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Finalizar'),
            ),
          ],
        ),
      ),
    );
  }
}
