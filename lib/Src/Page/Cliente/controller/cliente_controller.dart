import 'package:app_os/Src/Db/edepoites.dart';
import 'package:app_os/Src/Db/http_maager.dart';

import 'package:signals/signals_flutter.dart';

class ClienteController {
  // Add your controller logic here
  final clientes = signal<List<Map>>([]);
  // This could include methods for fetching, adding, updating, or deleting client data.
  final isLoading = signal<bool>(false);
  final sucessoCadastro = signal<bool>(false);
  final errorMessage = signal<String?>(null);
  List<Map> item = [];

  final _http = HttpManager();
  Future<void> getClients() async {
    // Logic to fetch clients
    isLoading.value = true;
    errorMessage.value = null;
    final result = await _http.restRequest(
      url: Endpoints.getClientes,
      method: HttpMethod.post,
    );
    if (result.containsKey('result')) {
      final clientesJson = List<Map>.from(result['result']);
      item = clientesJson.map((e) => e.cast<String, dynamic>()).toList();
      clientes.value = item;
    } else {
      errorMessage.value = result['error'] ?? 'Erro ao carregar clientes';
      clientes.value = [];
    }
  }

  Future<void> addClient(String name, String telefone, String endereco) async {
    isLoading.value = true;
    errorMessage.value = null;

    final body = {'name': name, 'telefone': telefone, 'endereco': endereco};

    final result = await _http.restRequest(
      url: Endpoints.enviaClientes, // Ajuste para o endpoint correto
      method: HttpMethod.post,
      body: body,
    );

    if (result.containsKey('id')) {
      // Cliente cadastrado com sucesso!
      final novoCliente = {
        'id': result['id'],
        'name': name,
        'telefone': telefone,
        'endereco': endereco,
      };

      // Atualiza a lista local de clientes
      item.add(novoCliente.cast<String, dynamic>());
      clientes.value = List<Map<String, dynamic>>.from(item);
    } else {
      errorMessage.value = result['error'] ?? 'Erro ao cadastrar cliente';
      clientes.value = [];
    }

    isLoading.value = false;
  }

  void updateClient(int clientId, String updatedName) {
    // Logic to update an existing client
  }

  void deleteClient(String clientId) {
    isLoading.value = true;
    errorMessage.value = null;
    _http
        .restRequest(
          url: Endpoints.deletarCliente,
          method: HttpMethod.post,
          body: {'objectId': clientId},
        )
        .then((result) {
          if (result.containsKey('message')) {
            // Cliente deletado com sucesso!
            item.removeWhere((client) => client['id'] == clientId);
            clientes.value = List<Map<String, dynamic>>.from(item);
          } else {
            errorMessage.value = result['error'] ?? 'Erro ao deletar cliente';
          }
        })
        .catchError((error) {
          errorMessage.value = 'Erro inesperado: $error';
        })
        .whenComplete(() {
          isLoading.value = false;
        }); // Finalmente, finaliza a operação
  }
}
