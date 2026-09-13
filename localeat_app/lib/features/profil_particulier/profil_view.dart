import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocalEatColors.fondCasse,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(color: LocalEatColors.vertPrincipal, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Text('CD', style: TextStyle(color: LocalEatColors.vertTresFonce, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 6),
                    const Text('Claire D.', style: LocalEatTypography.sousTitre),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _LigneProfil(icone: Icons.shopping_bag_outlined, label: 'Mes commandes'),
              _LigneProfil(
                icone: Icons.favorite_border,
                label: 'Producteurs favoris',
                onTap: () => context.push('/favoris'),
              ),
              const _LigneProfil(icone: Icons.location_on_outlined, label: 'Adresses'),
              const _LigneProfil(icone: Icons.notifications_none, label: 'Notifications'),
              const _LigneProfil(icone: Icons.settings_outlined, label: 'Paramètres'),
              const Divider(height: 32, color: LocalEatColors.bordure),
              TextButton(
                onPressed: () => context.go('/producteur'),
                child: const Text('Passer en espace producteur (démo)', style: LocalEatTypography.secondaire),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LigneProfil extends StatelessWidget {
  final IconData icone;
  final String label;
  final VoidCallback? onTap;
  const _LigneProfil({required this.icone, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icone, size: 18, color: LocalEatColors.texteSecondaire),
            const SizedBox(width: 10),
            Text(label, style: LocalEatTypography.corps),
          ],
        ),
      ),
    );
  }
}
