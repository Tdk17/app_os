import 'package:app_os/Src/Db/edepoites.dart';
import 'package:app_os/Src/Db/http_maager.dart';
import 'package:flutter/foundation.dart'; // ValueNotifier e afins

class OrcamentoController {
  final HttpManager _http = HttpManager();

  // Variáveis de estado
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);
  final ValueNotifier<List<Map<String, dynamic>>> orcamentos = ValueNotifier(
    [],
  );

  List<Map<String, dynamic>> item = [];

  Future<void> getOrcamentos() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _http.restRequest(
        url: Endpoints.getAllOrcamento,
        method: HttpMethod.post,
      );

      if (result.containsKey('result')) {
        final orcamentosJson = List<Map>.from(result['result']);
        item = orcamentosJson.map((e) => e.cast<String, dynamic>()).toList();
        orcamentos.value = item;
      } else {
        errorMessage.value = result['error'] ?? 'Erro ao carregar orçamentos.';
        orcamentos.value = [];
      }
    } catch (e) {
      errorMessage.value = 'Erro inesperado: $e';
      orcamentos.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletaOrcamento(String objectId) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _http.restRequest(
        url: Endpoints.deletarOrcamento,
        method: HttpMethod.post,
        body: {'objectId': objectId},
      );

      if (result.containsKey('message')) {
        debugPrint('Orçamento deletado com sucesso!');
        await getOrcamentos(); // Atualiza a lista após a exclusão
      } else {
        errorMessage.value = result['error'] ?? 'Erro ao deletar orçamento.';
      }
    } catch (e) {
      errorMessage.value = 'Erro inesperado: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> enviaOrcamento({
    required String corBase,
    required String formaPagamento,
    required String prazoEntrega,
    required String metragem,
    required String descricao,
    required String cliente,
    required String valor,
    required String tipoServico,
    required String status,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _http.restRequest(
        url: Endpoints.postAllOrcamento, // substitua com a URL correta
        method: HttpMethod.post,
        body: {
          'corBase': corBase,
          'formaPagamento': formaPagamento,
          'prazoEntrega': prazoEntrega,
          'metragem': metragem,
          'descricao': descricao,
          'cliente': cliente,
          'valor': valor,
          'tipoServico': tipoServico,
          'status': status,
        },
      );

      if (result.containsKey('result')) {
        print('Orçamento enviado com sucesso! ${result['result']}');
        // Se precisar, atualize a lista de orçamentos com o novo item

        final novoOrcamento = Map<String, dynamic>.from(result['result']);
        item.add(novoOrcamento);
        orcamentos.value = List.from(item);

        // Ou apenas exiba uma notificação de sucesso se preferir
        debugPrint('Orçamento enviado com sucesso!');
      } else {
        errorMessage.value = result['error'] ?? 'Erro ao enviar orçamento.';
        debugPrint('Erro ao enviar orçamento: ${result['error']}');
      }
    } catch (e) {
      errorMessage.value = 'Erro inesperado: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
