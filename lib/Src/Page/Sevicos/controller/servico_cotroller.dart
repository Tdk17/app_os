import 'package:app_os/Src/Db/edepoites.dart';
import 'package:app_os/Src/Db/http_maager.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ServicoCotroller {
  final servicos = signal<List<Map>>([]);
  final isLoading = signal<bool>(false);
  final sucessoCadastro = signal<bool>(false);
  final errorMessage = signal<String?>(null);

  List<Map> item = [];
  final _http = HttpManager();

  Future<void> getServicos() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await _http.restRequest(
      url: Endpoints.getAllservico,
      method: HttpMethod.post,
    );

    if (result.containsKey('result')) {
      final servicosJson = List<Map>.from(result['result']);
      item = servicosJson.map((e) => e.cast<String, dynamic>()).toList();
      servicos.value = item;
    } else {
      errorMessage.value = result['error'] ?? 'Erro ao carregar serviços';
      servicos.value = [];
    }

    isLoading.value = false;
  }

  Future<void> enviaServico({
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
        url: Endpoints.postAllServico,
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
        debugPrint('Serviço enviado com sucesso!');
      } else {
        errorMessage.value = result['error'] ?? 'Erro ao enviar serviço.';
      }
    } catch (e) {
      errorMessage.value = 'Erro inesperado: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// NOVA FUNÇÃO: Atualiza o status do serviço
  Future<void> atualizarStatusServico({
    required String objectId,
    required String novoStatus,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _http.restRequest(
        url: Endpoints.atualizaStatusServico,
        method: HttpMethod.post, // ou PATCH, conforme o backend
        body: {'objectId': objectId, 'status': novoStatus},
      );

      if (result.containsKey('result')) {
        debugPrint('Status atualizado com sucesso!$result');
      } else {
        errorMessage.value =
            result['error'] ?? 'Erro ao atualizar status do serviço.';
      }
    } catch (e) {
      errorMessage.value = 'Erro inesperado: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
