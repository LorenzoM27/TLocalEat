import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';

class ConfirmationView extends StatelessWidget {
  const ConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocalEatColors.fondCasse,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: LocalEatColors.vertPrincipal, size: 64),
            const SizedBox(height: 16),
            const Text('Commande confirmée !', style: LocalEatTypography.titre),
            const SizedBox(height: 6),
            const Text(
              'Vous recevrez une notification quand elle sera prête.',
              style: LocalEatTypography.secondaire,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: LocalEatColors.vertPrincipal,
                foregroundColor: LocalEatColors.vertTresFonce,
              ),
              onPressed: () => context.go('/'),
              child: const Text('Retour à la carte'),
            ),
          ],
        ),
      ),
    );
  }
}
