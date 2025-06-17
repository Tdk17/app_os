import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Aguardar a duração total da animação e redirecionar
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Texto "Brilhart" com animação de fade-in e brilho
            Image.asset('assets/logo.png', width: 290, height: 200)
                .animate(
                  onInit: (controller) => controller.forward(from: 0.0),
                  onPlay: (controller) => controller.repeat(reverse: true),
                  onComplete: (controller) => controller.forward(from: 5.0),
                )
                .fadeIn(duration: 1.5.seconds)
                .then(delay: 0.7.seconds)
                .shimmer(duration: 2.seconds)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 1.seconds,
                ),

            const SizedBox(height: 20),

            // Texto "Laqueamento" com fade-in atrasado
          ],
        ),
      ),
    );
  }
}
