import 'package:app_os/Src/Page/Cliente/controller/cliente_controller.dart';
import 'package:app_os/Src/Page/Or%C3%A7amento/controller/orcamento_controller.dart';
import 'package:app_os/Src/Page/Sevicos/controller/servico_cotroller.dart';
import 'package:app_os/Src/Page/home/controller/Faturamento_controller.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<ClienteController>(ClienteController());
  getIt.registerSingleton<ServicoCotroller>(ServicoCotroller());
  getIt.registerSingleton<FaturamentoController>(FaturamentoController());
  getIt.registerSingleton<OrcamentoController>(OrcamentoController());
}
