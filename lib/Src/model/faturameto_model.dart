class FaturamentosModel {
  String? valortotal;

  FaturamentosModel({this.valortotal});
  FaturamentosModel.fromJson(Map<String, dynamic> json) {
    valortotal = json['valortotal'];
  }
}
