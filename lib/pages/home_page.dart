import 'package:app_imc/utils/classificacaoIMC.dart';
import 'package:app_imc/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

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

  double totalIMC = 0.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calculadora de IMC'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: Image.network(
                  "https://as1.ftcdn.net/v2/jpg/04/02/03/42/1000_F_402034251_pd469Z7inajROMb4GMN0NV0kI8sRWhNB.jpg",
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 25),
              TextFieldWidget(
                  controller: nomeController, text: "Nome", keyboardType: TextInputType.name, icon: Icons.person),
              TextFieldWidget(
                controller: pesoController,
                text: "Peso",
                keyboardType: TextInputType.number,
                icon: Icons.balance,
              ),
              TextFieldWidget(
                controller: alturaController,
                text: "Altura",
                keyboardType: TextInputType.number,
                icon: Icons.height,
              ),
              TextButton(
                onPressed: () {
                  double peso;
                  double altura;
                  try {
                    peso = double.parse(pesoController.text);
                    altura = double.parse(alturaController.text);
                    totalIMC = _calculaIMC(peso, altura);
                  } catch (e) {
                    totalIMC = 0;
                  }
                  var classifica = classificacao.classificacaoIMC(totalIMC);
                  String resultado = _imprimeResultado(nomeController.text, totalIMC, classifica);

                  setState(() {
                    listaIMCs.add(resultado);
                  });
                },
                child: const Text('Calcular'),
              ),
              Expanded(
                child: ListView.builder(
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
      return 'Valores incorretos corrija por favor';
    } else {
      return '$nome - ${totalIMC.toStringAsFixed(2)} - $classificacao';
    }
  }
}
