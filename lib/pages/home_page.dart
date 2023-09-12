import 'package:app_imc/utils/classificacaoIMC.dart';
import 'package:app_imc/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var nomeController = TextEditingController();
  var pesoController = TextEditingController();
  var alturaController = TextEditingController();
  var listaIMCs = <String>[];
  var classificacao = ClassificacaoIMC();

  late SharedPreferences _prefs;
  double totalIMC = 0.0;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          child: ListView(
            // Use ListView em vez de Column
            children: [
              const SizedBox(
                height: 90,
                width: 90,
                child: CircleAvatar(
                  child: Icon(Icons.balance, size: 40),
                ),
              ),
              const SizedBox(height: 25),
              TextFieldWidget(
                controller: nomeController,
                text: "Nome",
                keyboardType: TextInputType.name,
                icon: Icons.person,
              ),
              TextFieldWidget(
                controller: pesoController,
                text: "Peso (em kg)",
                keyboardType: TextInputType.number,
                icon: Icons.line_weight,
              ),
              TextFieldWidget(
                controller: alturaController,
                text: "Altura (em metros)",
                keyboardType: TextInputType.number,
                icon: Icons.height,
              ),
              ElevatedButton(
                onPressed: () {
                  double peso;
                  double altura;
                  try {
                    peso = double.parse(pesoController.text);
                    altura = double.parse(alturaController.text);
                    totalIMC = _calculaIMC(peso, altura);
                    errorMessage = null;
                  } catch (e) {
                    totalIMC = 0;
                    errorMessage = 'Valores incorretos, por favor, corrija-os.';
                  }
                  var classifica = classificacao.classificacaoIMC(totalIMC);
                  String resultado = _imprimeResultado(nomeController.text, totalIMC, classifica);

                  setState(() {
                    listaIMCs.add(resultado);
                    _saveResult(resultado);
                  });

                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calculate),
                    SizedBox(width: 8),
                    Text('Calcular IMC'),
                  ],
                ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    listaIMCs.clear();
                  });
                },
                child: const Text('Limpar Resultados'),
              ),
              // Removido o Expanded para evitar o overflow
              ListView.builder(
                shrinkWrap: true,
                itemCount: listaIMCs.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    shadowColor: Colors.grey,
                    child: ListTile(
                      title: Text(
                        '⚖️ - ${listaIMCs[index]}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculaIMC(double peso, double altura) {
    return peso / (altura * altura);
  }

  String _imprimeResultado(String nome, double totalIMC, String classificacao) {
    if (totalIMC == 0) {
      return 'Valores incorretos, por favor, corrija-os.';
    } else {
      String resultado = '$nome - ${totalIMC.toStringAsFixed(2)} - $classificacao';

      _saveResult(resultado);

      return resultado;
    }
  }

  Future<void> _saveResult(String resultado) async {
    final List<String> results = _prefs.getStringList('results') ?? [];
    results.add(resultado);
    await _prefs.setStringList('results', results);
  }
}
