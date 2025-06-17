import 'package:app_os/Src/Db/edepoites.dart';
import 'package:app_os/Src/Db/http_maager.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class FaturamentoController {
  final faturamentos = signal<List<Map>>([]);
  final isLoading = signal<bool>(false);
  final sucessoCadastro = signal<bool>(false);
  final errorMessage = signal<String?>(null);
  List<Map> item = [];

  final _http = HttpManager();

  Future<void> getFaturamentos() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await _http.restRequest(
      url: Endpoints.getfaturamentos,
      method: HttpMethod.post,
    );

    if (result.containsKey('result')) {
      final responseData = result['result'];

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('valortotal')) {
        final valorString = responseData['valortotal'].toString();
        // Convertemos a string para double
        final valor = _parseValor(valorString);
        // Atualizamos a lista com apenas 1 item de faturamento para manter o sinal funcionando
        item = [
          {'valor': valor},
        ];
      } else {
        errorMessage.value = 'Formato de resposta inválido';
        item = [];
      }
    } else {
      errorMessage.value = result['error'] ?? 'Erro ao carregar faturamentos';
      item = [];
    }

    faturamentos.value = item;
    isLoading.value = false;
  }

  double _parseValor(String valorString) {
    // Remove R$, pontos de milhar e substitui vírgula por ponto
    final cleanString = valorString
        .replaceAll('R\$', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();
    return double.tryParse(cleanString) ?? 0.0;
  }

  /// Getter que soma o total de faturamento
  double get totalFaturamento {
    double total = 0.0;
    for (var fat in item) {
      final valor =
          double.tryParse(fat['valor'].toString().replaceAll(',', '.')) ?? 0.0;
      total += valor;
    }
    return total;
  }

  Future<void> enviaFaturamento({required String valorTotal}) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _http.restRequest(
        url: Endpoints.faturamentos,
        method: HttpMethod.post,
        body: {'valortotal': valorTotal},
      );

      if (result.containsKey('result')) {
        debugPrint('Faturamento enviado com sucesso! $result');
      } else {
        errorMessage.value = result['error'] ?? 'Erro ao enviar faturamento.';
      }
    } catch (e) {
      errorMessage.value = 'Erro inesperado: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
