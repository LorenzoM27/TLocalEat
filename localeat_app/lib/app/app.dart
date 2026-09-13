import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/colors.dart';

class LocalEatApp extends StatelessWidget {
  const LocalEatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LocalEat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: LocalEatColors.fondCasse,
        colorScheme: ColorScheme.fromSeed(
          seedColor: LocalEatColors.vertPrincipal,
          primary: LocalEatColors.vertPrincipal,
        ),
        fontFamily: 'Roboto',
      ),
      routerConfig: routerLocalEat,
    );
  }
}
