import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';

class AccueilProducteurView extends StatelessWidget {
  const AccueilProducteurView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocalEatColors.fondCasse,
      appBar: AppBar(
        backgroundColor: LocalEatColors.fondCasse,
        elevation: 0,
        title: const Text('Espace producteur', style: LocalEatTypography.sousTitre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TuileNavigation(
              icone: Icons.shopping_bag_outlined,
              titre: 'Commandes du jour',
              onTap: () => context.push('/producteur/commandes'),
            ),
            const SizedBox(height: 10),
            _TuileNavigation(
              icone: Icons.inventory_2_outlined,
              titre: 'Mes produits',
              onTap: () => context.push('/producteur/catalogue'),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text('Revenir à l\'espace particulier (démo)', style: LocalEatTypography.secondaire),
            ),
          ],
        ),
      ),
    );
  }
}

class _TuileNavigation extends StatelessWidget {
  final IconData icone;
  final String titre;
  final VoidCallback onTap;
  const _TuileNavigation({required this.icone, required this.titre, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: LocalEatColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: LocalEatColors.bordure),
        ),
        child: Row(
          children: [
            Icon(icone, color: LocalEatColors.vertPrincipal),
            const SizedBox(width: 12),
            Text(titre, style: LocalEatTypography.corps),
            const Spacer(),
            const Icon(Icons.chevron_right, color: LocalEatColors.texteMuted),
          ],
        ),
      ),
    );
  }
}
