import 'package:app_os/Src/Page/Sevicos/controller/servico_cotroller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ServicoScreen extends StatefulWidget {
  const ServicoScreen({super.key});

  @override
  State<ServicoScreen> createState() => _ServicoScreenState();
}

class _ServicoScreenState extends State<ServicoScreen> {
  final servicoController = GetIt.I<ServicoCotroller>();
  final List<int> expandedIndices = [];

  @override
  void initState() {
    super.initState();
    servicoController.getServicos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 34, 34, 34),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: const Text(
              'Preparo de Tintas ',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.construction,
                    size: 140,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Em Desenvolvimento',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Estamos trabalhando para trazer essa funcionalidade o mais breve possível!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
