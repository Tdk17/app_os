import 'package:app_os/Src/Componentes/navigation_botton.dart';
import 'package:app_os/Src/Page/Cliente/cliente_screen.dart';
import 'package:app_os/Src/Page/Or%C3%A7amento/or%C3%A7amento_screen.dart';
//import 'package:app_os/Src/Page/Or%C3%A7amento/pdf/pdf_viwe.dart';
import 'package:app_os/Src/Page/Sevicos/servico_screen.dart';
import 'package:app_os/Src/Page/Splash/splash_screen.dart';
import 'package:app_os/Src/Page/home/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final appRoutes = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

    /// Navegação com barra inferior
    ShellRoute(
      builder: (_, __, child) => Scaffold(
        backgroundColor: Color.fromARGB(255, 8, 8, 8),
        body: child,
        bottomNavigationBar: const HomeBottomNav(), // Componente global
      ),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),

        GoRoute(path: '/clientes', builder: (_, __) => const ClienteScreen()),
        GoRoute(path: '/boletos', builder: (_, __) => Orcamentos()),
        GoRoute(path: '/servicos', builder: (_, __) => const ServicoScreen()),
      ],
    ),

    // GoRoute(path: '/register', builder: (context, state) => const Register()),
    // GoRoute(path: '/profile', builder: (context, state) => const Profile()),
  ],
);
