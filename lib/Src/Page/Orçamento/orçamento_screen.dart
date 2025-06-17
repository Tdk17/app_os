// Continua seus imports

import 'package:app_os/Src/Page/Sevicos/controller/servico_cotroller.dart';
import 'package:app_os/Src/Page/home/controller/Faturamento_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:app_os/Src/Page/Orçamento/pdf/pdf_viwe.dart';
import 'package:app_os/Src/Page/Orçamento/controller/orcamento_controller.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Orcamentos extends StatefulWidget {
  const Orcamentos({super.key});

  @override
  State<Orcamentos> createState() => _OrcamentosState();
}

class _OrcamentosState extends State<Orcamentos> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final statusController = TextEditingController(text: 'Aguardando');
  final corBaseController = TextEditingController();
  final clienteController = TextEditingController();
  final tipoServicoController = TextEditingController();
  final descricaoController = TextEditingController();
  final valorController = TextEditingController();
  final formaPagamentoController = TextEditingController();
  final prazoEntregaController = TextEditingController();
  final metragemController = TextEditingController();
  final metragemAdicionalController = TextEditingController();
  final _orcamentoController = GetIt.I<OrcamentoController>();
  final servicoController = GetIt.I<ServicoCotroller>();
  final faturamentoController = GetIt.I<FaturamentoController>();

  double valorTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _orcamentoController.getOrcamentos();
  }

  final valorFormatter = MoneyInputFormatter(
    leadingSymbol: 'R\$ ',
    useSymbolPadding: true,
    thousandSeparator: ThousandSeparator.Period,
  );

  final prazoEntregaFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Future<Uint8List> loadAsset() async {
    return await rootBundle
        .load('assets/logoPreta.png')
        .then((data) => data.buffer.asUint8List());
  }

  Future<void> _creatPdf(
    BuildContext context,
    TextEditingController cliente,
    TextEditingController corBase,
    TextEditingController tipoServico,
    TextEditingController metragem,
    TextEditingController? metragemAdicional,
    TextEditingController descricao,
    double valorTotal,
    TextEditingController formaPagamento,
    TextEditingController prazoEntrega,
  ) async {
    final pdf = pw.Document();
    final imageBytes = await loadAsset();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
              color: PdfColor.fromInt(0xFFFFFF),
              width: PdfPageFormat.a4.width - 40,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 20),
                  pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(imageBytes),
                      width: 200,
                      height: 200,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Center(
                    child: pw.Container(
                      width: 1000,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          top: pw.BorderSide(
                            width: 1,
                            color: PdfColor.fromInt(0xFF000000),
                          ),
                          bottom: pw.BorderSide(
                            width: 1,
                            color: PdfColor.fromInt(0xFF000000),
                          ),
                          left: pw.BorderSide(
                            width: 1,
                            color: PdfColor.fromInt(0xFF000000),
                          ),
                          right: pw.BorderSide(
                            width: 1,
                            color: PdfColor.fromInt(0xFF000000),
                          ),
                        ),
                      ),
                      child: pw.Padding(
                        padding: pw.EdgeInsets.symmetric(vertical: 10),
                        child: pw.Center(
                          child: pw.Text(
                            'Orçamento',
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildOrcamentoDetails(
                    cliente,
                    corBase,
                    tipoServico,
                    descricao,
                    valorTotal,
                    formaPagamento,
                    prazoEntrega,
                    metragem,
                  ),
                  pw.Spacer(),
                  _buildFooter(),
                ],
              ),
            ),
          );
        },
      ),
    );

    Directory dir;
    try {
      dir = await getApplicationDocumentsDirectory();
    } catch (e) {
      debugPrint('Erro ao obter path provider: $e');
      dir = Directory.systemTemp;
    }

    final file = File('${dir.path}/${cliente.text}.pdf');
    await file.writeAsBytes(await pdf.save());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerPage(file, cliente.text),
      ),
    );
  }

  pw.Widget _buildOrcamentoDetails(
    TextEditingController cliente,
    TextEditingController corBase,
    TextEditingController tipoServico,
    TextEditingController descricao,
    double valorTotal,
    TextEditingController formaPagamento,
    TextEditingController prazoEntrega,
    TextEditingController metragem,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 20),
        pw.Text('Cliente: ${cliente.text}'),
        pw.Text('Prazo de Entrega: ${prazoEntrega.text}'),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
          data: [
            ['Dados de Serviços', 'Trabalhos'],
            ['Cor Base', corBase.text],
            ['Tipo de Serviço', tipoServico.text],
            ['Metragem', metragem.text],

            ['Descrição', descricao.text],
            ['Forma de Pagamento', '%50 de Entrada e %50 na Entrega'],
            ['Pix', 'CNPJ : 25422272000100'],
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
          data: [
            ['          ', 'Valor Total'],
            [
              '                ',
              'R\$ ${NumberFormat("#,##0.00", "pt_BR").format(valorTotal)}',
            ],
          ],
        ),
      ],
    );
  }

  pw.Widget _buildFooter() {
    return pw.Align(
      alignment: pw.Alignment.center,
      child: pw.Column(
        children: [
          pw.Text(
            'Brilhart laqueamento de móveis',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'Rua Tiroleses, 835 (fundos)',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'Bairro Capitais - Sc',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'E-mail: brilhartlacas@gmail.com',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'Fone: (47) 99273-3668',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
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
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: _orcamentoController.orcamentos,
              builder: (context, orcamentos, _) {
                if (_orcamentoController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_orcamentoController.errorMessage.value != null) {
                  return Center(
                    child: Text(_orcamentoController.errorMessage.value!),
                  );
                }
                if (orcamentos.isEmpty) {
                  return const Center(
                    child: Text('Nenhum orçamento encontrado'),
                  );
                }
                return ListView.builder(
                  itemCount: orcamentos.length,
                  itemBuilder: (context, index) {
                    final orcamento = orcamentos[index];
                    return Card(
                      child: ExpansionTile(
                        title: Text(
                          orcamento['cliente'] ?? 'Sem Cliente',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Valor: R\$ ${orcamento['valor'] ?? '0.00'}',
                        ),
                        trailing: Text(
                          orcamento['status'] ?? 'Pendente',
                          style: TextStyle(
                            color: orcamento['status'] == 'Aprovado'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        children: [
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cor Base: ${orcamento['corBase']}'),
                                Text(
                                  'Tipo de Serviço: ${orcamento['tipoServico']}',
                                ),
                                Text('Metragem: ${orcamento['metragem']} m²'),
                                Text(
                                  'Descrição: ${orcamento['descricao'] ?? ''}',
                                ),
                                Text(
                                  'Forma de Pagamento: ${orcamento['formaPagamento'] ?? ''}',
                                ),
                                Text(
                                  'Prazo de Entrega: ${orcamento['prazoEntrega'] ?? ''}',
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _preencherCampos(orcamento);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        27,
                                        27,
                                        27,
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      content: SizedBox(
                                        width: 600,
                                        child: _buildFormulario(),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 27, 27, 27),
                contentPadding: EdgeInsets.zero,
                content: SizedBox(width: 600, child: _buildFormulario()),
              );
            },
          );
        },
        child: const Icon(Icons.receipt, size: 35, color: Colors.black),
      ),
    );
  }

  void _preencherCampos(Map<String, dynamic> orcamento) {
    clienteController.text = orcamento['cliente'] ?? '';
    corBaseController.text = orcamento['corBase'] ?? '';
    tipoServicoController.text = orcamento['tipoServico'] ?? '';
    metragemController.text = '${orcamento['metragem'] ?? ''} m²';
    descricaoController.text = orcamento['descricao'] ?? '';
    formaPagamentoController.text = orcamento['formaPagamento'] ?? '';
    prazoEntregaController.text = orcamento['prazoEntrega'] ?? '';
    statusController.text = orcamento['status'] ?? '';

    // Aqui é a correção:
    valorTotal =
        double.tryParse((orcamento['valor'] ?? '0.0').replaceAll(',', '.')) ??
        0.0;
    valorController.text = orcamento['valor'] ?? '0.0';
  }

  Widget _buildFormulario() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Orçamento',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _creatPdf(
                          context,
                          clienteController,
                          corBaseController,
                          tipoServicoController,
                          metragemController,
                          metragemAdicionalController,
                          descricaoController,
                          valorTotal,
                          formaPagamentoController,
                          prazoEntregaController,
                        );
                      }
                      context.pop(); // Fecha o modal
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: clienteController,
                decoration: const InputDecoration(
                  labelText: 'Cliente',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: corBaseController,
                decoration: const InputDecoration(
                  labelText: 'Cor Base',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: tipoServicoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Serviço',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: metragemController,
                decoration: const InputDecoration(
                  labelText: 'Metragem ',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
                onChanged: (value) {
                  // Remove qualquer "m²" antigo e reanexa corretamente

                  // Evita repetir o sufixo e reseta o texto formatado
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: descricaoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: valorController,
                keyboardType: TextInputType.number,
                inputFormatters: [valorFormatter],
                decoration: const InputDecoration(
                  labelText: 'Valor do Serviço',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
                onChanged: (value) {
                  setState(() {
                    final cleanedValue = value
                        .replaceAll(RegExp(r'[^\d,]'), '')
                        .replaceAll(',', '.');
                    valorTotal = double.tryParse(cleanedValue) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: formaPagamentoController,
                decoration: const InputDecoration(
                  labelText: 'Forma de Pagamento',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: prazoEntregaController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [prazoEntregaFormatter],
                decoration: const InputDecoration(
                  labelText: 'Prazo de Entrega',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    prazoEntregaController.text = DateFormat(
                      'dd/MM/yyyy',
                    ).format(pickedDate);
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        statusController.text = "Em Processo";
                        String valorFormatado = valorController.text
                            .replaceAll('.', '')
                            .replaceAll(',', '.');
                        // 1️⃣ Envia para a tabela de serviços
                        await servicoController.enviaServico(
                          corBase: corBaseController.text,
                          formaPagamento: formaPagamentoController.text,
                          prazoEntrega: prazoEntregaController.text,
                          metragem: metragemController.text,
                          descricao: descricaoController.text,
                          cliente: clienteController.text,
                          valor: valorFormatado,
                          tipoServico: tipoServicoController.text,
                          status: statusController.text,
                        );

                        // 2️⃣ Deleta o orçamento do Parse
                        // Você precisa do objectId do orçamento para isso
                        final orcamento = _orcamentoController.orcamentos.value
                            .firstWhere(
                              (o) => o['cliente'] == clienteController.text,
                              orElse: () => {},
                            );
                        if (orcamento.isNotEmpty && orcamento['id'] != null) {
                          await _orcamentoController.deletaOrcamento(
                            orcamento['id'],
                          );
                        }

                        // 3️⃣ Envia faturamento (opcional)
                        await faturamentoController.enviaFaturamento(
                          valorTotal: valorController.text,
                        );

                        context.pop(); // fecha modal
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Serviço'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Formata o valor para a API (transforma "1.234,56" em "1234.56")
                        String valorFormatado = valorController.text
                            .replaceAll('.', '')
                            .replaceAll(',', '.');
                        await _orcamentoController.enviaOrcamento(
                          corBase: corBaseController.text,
                          formaPagamento: formaPagamentoController.text,
                          prazoEntrega: prazoEntregaController.text,
                          metragem: metragemController.text,
                          descricao: descricaoController.text,
                          cliente: clienteController.text,
                          valor: valorFormatado,
                          tipoServico: tipoServicoController.text,
                          status: statusController.text,
                        );
                        context.pop(); // Usando GoRouter
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Orçamento'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
