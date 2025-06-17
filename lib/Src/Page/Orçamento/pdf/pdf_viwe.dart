import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class PdfViewerPage extends StatelessWidget {
  final File pdfFile;
  final String cliente;

  const PdfViewerPage(this.pdfFile, this.cliente, {super.key});

  Future<void> savePdf(File pdfFile) async {
    final directory = Directory('/storage/emulated/0/Documents');
    final path = directory.path;
    final file = File('$path/$cliente.pdf');
    await pdfFile.copy(file.path);
    print('Arquivo salvo em: $path');
  }

  Future<void> sendPdfToWhatsApp(BuildContext context) async {
    // 🔥 Corrige aqui: declara directory corretamente
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível acessar o diretório de armazenamento.',
          ),
        ),
      );
      return;
    }

    final filePath = '${directory.path}/$cliente.pdf';

    // Salva o arquivo localmente (se ainda não foi salvo)
    if (!await File(filePath).exists()) {
      await pdfFile.copy(filePath);
    }

    TextEditingController phoneController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 27, 27, 27),
          title: const Text(
            'Enviar PDF por WhatsApp',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Número com DDD (ex: 5511999999999)',
              labelStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.orangeAccent),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final number = phoneController.text.trim();
                if (number.isNotEmpty) {
                  context.pop(); // Fecha o diálogo

                  final whatsappUrl =
                      'https://wa.me/$number?text=Olá, aqui está o PDF solicitado: $filePath';

                  // Usa o canLaunchUrl para verificar se pode abrir
                  if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                    await launchUrl(
                      Uri.parse(whatsappUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'O WhatsApp não está instalado ou não foi possível abrir.',
                        ),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      appBar: AppBar(
        title: const Text(
          'Visualizador de PDF',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              savePdf(pdfFile);
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.send),
          //   onPressed: () {
          //     sendPdfToWhatsApp(context);
          //   },
          // ),
        ],
      ),
      body: SfPdfViewer.file(pdfFile),
    );
  }
}
