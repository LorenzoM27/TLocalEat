import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'theme/colors.dart';

class ShellParticulier extends StatelessWidget {
  final Widget child;
  const ShellParticulier({super.key, required this.child});

  int _indexActuel(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/favoris')) return 1;
    if (location.startsWith('/profil')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _indexActuel(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: LocalEatColors.vertPrincipal,
        unselectedItemColor: LocalEatColors.texteMuted,
        showUnselectedLabels: true,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/favoris');
              break;
            case 2:
              context.go('/profil');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Carte'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favoris'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
