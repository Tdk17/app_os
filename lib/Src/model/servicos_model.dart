class ServicoModel {
  String? id;
  String? cliente;
  String? corBase;
  String? formaPagamento;
  String? metragem;
  String? prazoEntrega;
  String? descricao;
  String? valor;
  String? tipoServico;
  String? status;

  ServicoModel({
    this.cliente,
    this.corBase,
    this.metragem,
    this.prazoEntrega,
    this.formaPagamento,
    this.descricao,
    this.valor,
    this.tipoServico,
    this.status,
  });
  ServicoModel.fromJson(Map<String, dynamic> json) {
    id = json['objectId'];
    cliente = json['cliente'];
    corBase = json['corBase'];
    formaPagamento = json['formaPagamento'];
    metragem = json['metragem'];
    prazoEntrega = json['prazoEntrega'];
    descricao = json['descricao'];
    valor = json['valor'];
    tipoServico = json['tipoServico'];
    status = json['status'];
  }
}
