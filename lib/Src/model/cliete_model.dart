class ClienteModel {
  String? name;
  String? endereco;
  String? telefone;
  String? id;

  ClienteModel({this.name, this.endereco, this.telefone, this.id});

  ClienteModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    endereco = json['endereco'];
    telefone = json['telefone'];
    id = json['objectId'];
  }
}
