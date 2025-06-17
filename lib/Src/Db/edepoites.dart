const String baseUrl = 'https://parseapi.back4app.com/functions';

abstract class Endpoints {
  // ORÇAMENTOS
  static const String postAllOrcamento = '$baseUrl/orcamento';
  static const String getAllOrcamento = '$baseUrl/get-orcamento';
  static const String deletarOrcamento = '$baseUrl/deleteOrcamento';
  //CLIENTES
  static const String getClientes = '$baseUrl/get-clientes';
  static const String enviaClientes = '$baseUrl/cliente';
  static const String deletarCliente = '$baseUrl/deleteCliente';
  //SERVIÇOS
  static const String postAllServico = '$baseUrl/Servico';
  static const String getAllservico = '$baseUrl/get-servico';
  static const String deleteServico = '$baseUrl/deleteServico';
  static const String postAllServicoConcluidos = '$baseUrl/ServicoConcluido';
  static const String getAllServicoConcluidos =
      '$baseUrl/get-servicoConcluidos';
  static const String atualizaStatusServico = '$baseUrl/atualizarStatusServico';
  // FATURAMENTO
  static const String faturamentos = '$baseUrl/faturamentos';
  static const String getfaturamentos = '$baseUrl/getTotalFaturamento';
}
