import 'package:app_os/Src/Componentes/app_theme.dart';
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    onPrimary: const Color.fromARGB(255, 0, 0, 0),
    onSecondary: const Color.fromARGB(255, 0, 0, 0),
    onSurface: AppColors.textSecondary,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.text),
    bodyMedium: TextStyle(color: AppColors.textSecondary),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.surface,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
  ),
  cardColor: AppColors.surface,
);
