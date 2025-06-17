import 'package:app_os/Src/Page/Sevicos/controller/servico_cotroller.dart';
import 'package:app_os/Src/Page/home/controller/Faturamento_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<int> expandedIndices = [];
  final servicoController = GetIt.I<ServicoCotroller>();
  final faturamentoController = GetIt.I<FaturamentoController>();
  bool _showTotalFaturamento = false;
  DateTime? selectedDate;
  List<DateTime> datasPendentes = [];

  @override
  void initState() {
    super.initState();
    servicoController.getServicos();
    faturamentoController.getFaturamentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Watch((context) {
        final servicos = servicoController.servicos.value;
        final hoje = DateTime.now();

        final emProducaoVencidos = servicos
            .where((servico) {
              final status = servico['status'];
              final data = _parseDate(servico['prazoEntrega'] ?? '');
              return status == 'Em Produção' &&
                  data != null &&
                  data.isBefore(hoje);
            })
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        datasPendentes = emProducaoVencidos
            .map((e) => _parseDate(e['prazoEntrega'])!)
            .toList();

        final filteredServicos = servicos.where((servico) {
          final dataEntrega = _parseDate(servico['prazoEntrega'] ?? '');
          if (dataEntrega == null) return false;

          if (selectedDate != null) {
            return isSameDay(dataEntrega, selectedDate!);
          } else {
            return !dataEntrega.isBefore(
              DateTime(hoje.year, hoje.month, hoje.day),
            );
          }
        }).toList();

        return Column(
          children: [
            _buildAppBar(emProducaoVencidos.length),
            _buildDatePickerButton(emProducaoVencidos),

            Expanded(
              child: filteredServicos.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum serviço encontrado.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredServicos.length,
                      itemBuilder: (context, index) {
                        final servico = filteredServicos[index];
                        final isExpanded = expandedIndices.contains(index);
                        final isConcluido = servico['status'] == 'Concluído';

                        return Opacity(
                          opacity: isConcluido ? 0.5 : 1.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 34, 34, 34),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          servico['cliente'] ??
                                              'Serviço Desconhecido',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (!isConcluido) {
                                            _showConcluirDialog(servico);
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isConcluido
                                                ? Colors.green
                                                : Colors.orange,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          child: Text(
                                            servico['status'] ?? 'Aguardando',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Data de entrega: ${servico['prazoEntrega'] ?? 'Sem data'}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedCrossFade(
                                    firstChild: Text(
                                      _truncate(
                                        servico['descricao'] ?? 'Desconhecido',
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    secondChild: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          servico['descricao'] ??
                                              'Desconhecido',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Valor: R\$ ${servico['valor'] ?? '0.00'}',
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Metragem: ${servico['metragem'] ?? 'N/A'}',
                                        ),
                                      ],
                                    ),
                                    crossFadeState: isExpanded
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    duration: const Duration(milliseconds: 300),
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isExpanded) {
                                            expandedIndices.remove(index);
                                          } else {
                                            expandedIndices.add(index);
                                          }
                                        });
                                      },
                                      child: Text(
                                        isExpanded ? 'Ver menos' : 'Ver mais',
                                        style: const TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  void _showConcluirDialog(Map servico) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 27, 27, 27),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Concluir Serviço',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Deseja marcar este serviço como Concluído?',
            style: TextStyle(color: Colors.white70),
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
                Navigator.of(context).pop();
                await servicoController.atualizarStatusServico(
                  objectId: servico['objectId'] ?? servico['id'] ?? '',
                  novoStatus: 'Concluído',
                );
                await servicoController.getServicos();
                setState(() {});
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Concluir'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDatePickerButton(List<Map<String, dynamic>> emProducaoVencidos) {
    DateTime initialDate = selectedDate ?? DateTime.now();
    if (emProducaoVencidos.isNotEmpty) {
      emProducaoVencidos.sort((a, b) {
        final aDate = _parseDate(a['prazoEntrega']);
        final bDate = _parseDate(b['prazoEntrega']);
        return aDate!.compareTo(bDate!);
      });
      initialDate =
          _parseDate(emProducaoVencidos.first['prazoEntrega']) ?? initialDate;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Colors.orangeAccent,
                      onPrimary: Colors.black,
                      surface: Color.fromARGB(255, 34, 34, 34),
                      onSurface: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              setState(() {
                selectedDate = pickedDate;
              });
            }
          },
          icon: Stack(
            children: [
              const Icon(Icons.calendar_today, color: Colors.black),
              if (emProducaoVencidos.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          label: Text(
            selectedDate != null
                ? 'Data de entrega: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'
                : emProducaoVencidos.isNotEmpty
                ? 'Filtrar por Data - ${emProducaoVencidos.length} pendente(s)'
                : 'Filtrar por Data de Entrega',
            style: const TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  DateTime? _parseDate(String? dateString) {
    if (dateString == null) return null;
    try {
      return DateFormat('dd/MM/yyyy').parse(dateString);
    } catch (_) {
      try {
        return DateFormat('dd-MM-yyyy').parse(dateString);
      } catch (_) {
        return null;
      }
    }
  }

  Widget _buildAppBar(int osVencidas) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 34, 34, 34),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (osVencidas > 0)
            Stack(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orangeAccent,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$osVencidas',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            const SizedBox(width: 24),
          Flexible(
            child: Image.asset('assets/logo.png', width: 290, height: 100),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _showTotalFaturamento = !_showTotalFaturamento;
                  });
                },
                icon: const Icon(
                  Icons.attach_money_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              if (_showTotalFaturamento)
                Watch((context) {
                  final total = faturamentoController.totalFaturamento;
                  return Text(
                    total > 0 ? 'R\$ ${total.toStringAsFixed(2)}' : 'R\$ 0,00',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
            ],
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _truncate(String text, {int maxChars = 50}) {
    if (text.length <= maxChars) return text;
    return '${text.substring(0, maxChars)}...';
  }
}
