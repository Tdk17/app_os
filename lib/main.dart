import 'package:app_os/Src/Componentes/them_data.dart';
import 'package:app_os/Src/Db/injection.dart';
import 'package:app_os/Src/Routes/routes.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'App Brilhart',
      theme: appTheme,
      routerConfig: appRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
