import 'package:flutter/material.dart';
import 'results.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _doenca;
  String? _geocode;
  int _ew_start = 0;
  int _ew_end = 0;
  int _ey_start = 0;
  int _ey_end = 0;
  dynamic w_start_cases_est;
  dynamic w_start_cases;
  dynamic w_start_level;
  dynamic w_start_temp_min;
  dynamic w_start_temp_max;
  dynamic w_end_cases_est;
  dynamic w_end_cases;
  dynamic w_end_level;
  dynamic w_end_temp_min;
  dynamic w_end_temp_max;

  TextEditingController _controlador_data_inicial = TextEditingController();
  TextEditingController _controlador_data_final = TextEditingController();

  void dropDownCallbackdoenca(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        _doenca = selectedvalue;
      });
    }
  }

  void dropDownCallbackcity(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        _geocode = selectedvalue;
      });
    }
  }

  int getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDayOfYear = date.difference(firstDayOfYear).inDays;
    final firstDayOfWeek = firstDayOfYear.weekday;
    final weekNumber =
        ((daysSinceFirstDayOfYear + firstDayOfWeek - 1) / 7).ceil();
    return weekNumber;
  }

  Future<void> escolheDataInicial(TextEditingController controller) async {
    DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(0000),
      lastDate: DateTime(2100),
    );
    setState(() {
      _ew_start = getWeekOfYear(data!);
      _ey_start = data.year;
      controller.text = data.toString().split(" ")[0];
    });
  }

  Future<void> escolheDataFinal(TextEditingController controller) async {
    DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(0000),
      lastDate: DateTime(2100),
    );
    setState(() {
      _ew_end = getWeekOfYear(data!);
      _ey_end = data.year;
      controller.text = data.toString().split(" ")[0];
    });
  }

  Future coletaDados() async {
    String url = "https://info.dengue.mat.br/api/alertcity";
    String queryParameters =
        "geocode=$_geocode&disease=$_doenca&format=json&ew_start=$_ew_start&ew_end=$_ew_end&ey_start=$_ey_start&ey_end=$_ey_end";
    /*String queryParameters =
        "geocode=3304557&disease=dengue&format=json&ew_start=1&ew_end=50&ey_start=2017&ey_end=2017";*/
    Uri uri = Uri.parse("$url?$queryParameters");

    try {
      http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        print(
            "Query = geocode=$_geocode&disease=$_doenca&format=json&ew_start=$_ew_start&ew_end=$_ew_end&ey_start=$_ey_start&ey_end=$_ey_end");
        print(response.body);
        List<dynamic> dados = jsonDecode(response.body);

        w_start_cases_est = dados[0]["casos_est"];
        w_start_cases = dados[0]["casos"];
        w_start_level = dados[0]["nivel"];
        w_start_temp_min = dados[0]["tempmin"];
        w_start_temp_max = dados[0]["tempmax"];
        w_end_cases_est = dados[1]["casos_est"];
        w_end_cases = dados[1]["casos"];
        w_end_level = dados[1]["nivel"];
        w_end_temp_min = dados[1]["tempmin"];
        w_end_temp_max = dados[1]["tempmax"];

      } else {
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação: $e');
    }
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
          children: [
            Text("Selecione uma Doença (Dengue, Zika, Chikungunya), uma Capital Estadual e datas Inicial e Final de procura."),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: DropdownButtonFormField(
                    style: TextStyle(fontSize: 13, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'DOENÇA',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: const [
                      DropdownMenuItem(
                        child: Text("Dengue"),
                        value: "dengue",
                      ),
                      DropdownMenuItem(
                        child: Text("Chikungunya"),
                        value: "chikungunya",
                      ),
                      DropdownMenuItem(
                        child: Text("Zika"),
                        value: "zika",
                      ),
                    ],
                    value: _doenca,
                    onChanged: dropDownCallbackdoenca,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 6,
                  child: DropdownButtonFormField(
                    style: TextStyle(fontSize: 13, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'CIDADE',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: const [
                      DropdownMenuItem(
                        child: Text("Aracaju (SE)"),
                        value: "2800308",
                      ),
                      DropdownMenuItem(
                        child: Text("Belém (PA)"),
                        value: "1501402",
                      ),
                      DropdownMenuItem(
                        child: Text("Belo Horizonte (MG)"),
                        value: "3106200",
                      ),
                      DropdownMenuItem(
                        child: Text("Boa Vista (RR)"),
                        value: "1400100",
                      ),
                      DropdownMenuItem(
                        child: Text("Campo Grande (MS)"),
                        value: "5002704",
                      ),
                      DropdownMenuItem(
                        child: Text("Cuiabá (MT)"),
                        value: "5103403",
                      ),
                      DropdownMenuItem(
                        child: Text("Curitiba (PR)"),
                        value: "4106902",
                      ),
                      DropdownMenuItem(
                        child: Text("Florianópolis (SC)"),
                        value: "4205407",
                      ),
                      DropdownMenuItem(
                        child: Text("Fortaleza (CE)"),
                        value: "2304400",
                      ),
                      DropdownMenuItem(
                        child: Text("Goiânia (GO)"),
                        value: "5208707",
                      ),
                      DropdownMenuItem(
                        child: Text("João Pessoa (PB)"),
                        value: "2507507",
                      ),
                      DropdownMenuItem(
                        child: Text("Macapá (AP)"),
                        value: "1600303",
                      ),
                      DropdownMenuItem(
                        child: Text("Maceió (AL)"),
                        value: "2704302",
                      ),
                      DropdownMenuItem(
                        child: Text("Manaus (AM)"),
                        value: "1302603",
                      ),
                      DropdownMenuItem(
                        child: Text("Natal (RN)"),
                        value: "2408102",
                      ),
                      DropdownMenuItem(
                        child: Text("Palmas (TO)"),
                        value: "1721000",
                      ),
                      DropdownMenuItem(
                        child: Text("Porto Alegre (RS)"),
                        value: "4314902",
                      ),
                      DropdownMenuItem(
                        child: Text("Porto Velho (RO)"),
                        value: "1100205",
                      ),
                      DropdownMenuItem(
                        child: Text("Recife (PE)"),
                        value: "2611606",
                      ),
                      DropdownMenuItem(
                        child: Text("Rio Branco (AC)"),
                        value: "1200401",
                      ),
                      DropdownMenuItem(
                        child: Text("Rio de Janeiro (RJ)"),
                        value: "3304557",
                      ),
                      DropdownMenuItem(
                        child: Text("Salvador (BA)"),
                        value: "2927408",
                      ),
                      DropdownMenuItem(
                        child: Text("São Luís (MA)"),
                        value: "2111300",
                      ),
                      DropdownMenuItem(
                        child: Text("São Paulo (SP)"),
                        value: "3550308",
                      ),
                      DropdownMenuItem(
                        child: Text("Teresina (PI)"),
                        value: "2211001",
                      ),
                      DropdownMenuItem(
                        child: Text("Vitória (ES)"),
                        value: "3205309",
                      ),
                      DropdownMenuItem(
                        child: Text("Distrito Federal (DF)"),
                        value: "5300108",
                      ),
                    ],
                    value: _geocode,
                    onChanged: dropDownCallbackcity,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'DATA INICIAL',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {
                escolheDataInicial(_controlador_data_inicial);
              },
              controller: _controlador_data_inicial,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'DATA FINAL',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {
                escolheDataFinal(_controlador_data_final);
              },
              controller: _controlador_data_final,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                coletaDados().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Results(
                        doenca: _doenca,
                        geocode: _geocode,
                        data_inicial: _controlador_data_inicial.text,
                        data_final: _controlador_data_final.text,
                        startEstimatedCases: w_start_cases_est,
                        startCases: w_start_cases,
                        startLevel: w_start_level,
                        startTempMin: w_start_temp_min,
                        startTempMax: w_start_temp_max,
                        endEstimatedCases: w_end_cases_est,
                        endCases: w_end_cases,
                        endLevel: w_end_level,
                        endTempMin: w_end_temp_min,
                        endTempMax: w_end_temp_max,
                      ),
                    ),
                  );
                });
              },
              child: Text("Confirmar"),
            ),
          ],
        ),
      ),
    );
  }
}
