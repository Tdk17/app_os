import 'package:app_os/Src/Page/Cliente/controller/cliente_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final clienteControiller = GetIt.I<ClienteController>();

  @override
  void initState() {
    super.initState();
    clienteControiller.getClients();
  }

  final telefoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'\d')},
  );

  String formatTelefone(String telefone) {
    telefoneFormatter.clear();
    telefoneFormatter.formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: telefone),
    );
    return telefoneFormatter.getMaskedText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 34, 34, 34),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 290,
                    height: 100,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Watch((context) {
                final clienteListe = clienteControiller.clientes.value;
                return ListView.builder(
                  itemCount: clienteListe.length,
                  itemBuilder: (context, index) {
                    final cliente = clienteListe[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          cliente['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatTelefone(cliente['telefone'] ?? ''),
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(cliente['endereco'] ?? ''),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            clienteControiller.deleteClient(cliente['id']);
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final nameController = TextEditingController();
              final telefoneController = TextEditingController();
              final enderecoController = TextEditingController();

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text(
                  'Cadastrar Cliente',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: telefoneController,
                        decoration: InputDecoration(
                          labelText: 'Telefone',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: enderecoController,
                        decoration: InputDecoration(
                          labelText: 'Endereço',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.home),
                        ),
                      ),
                    ],
                  ),
                ),
                actionsPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final name = nameController.text.trim();
                      final telefone = telefoneController.text.trim();
                      final endereco = enderecoController.text.trim();

                      if (name.isEmpty ||
                          telefone.isEmpty ||
                          endereco.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Preencha todos os campos.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      await clienteControiller.addClient(
                        name,
                        telefone,
                        endereco,
                      );
                      Navigator.of(context).pop(); // Fecha o diálogo
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.person_add_alt_1,
          size: 35,
          color: Colors.black,
        ),
      ),
    );
  }
}
