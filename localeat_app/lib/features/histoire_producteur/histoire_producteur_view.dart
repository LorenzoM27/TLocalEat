import 'package:flutter/material.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../models/producteur.dart';

/// Écran sobre, volontairement court (décision produit : "pas un livre") —
/// méthode de production, origine, histoire de l'exploitation.
class HistoireProducteurView extends StatelessWidget {
  final Producteur producteur;
  const HistoireProducteurView({super.key, required this.producteur});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocalEatColors.fondCasse,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                children: [
                  Text(producteur.nomBoutique, style: LocalEatTypography.titre),
                  if (producteur.anneeCreationExploitation != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Depuis ${producteur.anneeCreationExploitation} · exploitation familiale',
                        style: LocalEatTypography.secondaire,
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (producteur.methodeProduction != null) ...[
                    const Text('Méthode', style: LocalEatTypography.secondaire),
                    const SizedBox(height: 4),
                    Text(producteur.methodeProduction!, style: LocalEatTypography.corps),
                    const SizedBox(height: 16),
                  ],
                  if (producteur.histoire != null) ...[
                    const Text('L\'exploitation', style: LocalEatTypography.secondaire),
                    const SizedBox(height: 4),
                    Text(producteur.histoire!, style: LocalEatTypography.corps),
                    const SizedBox(height: 16),
                  ],
                  Wrap(
                    spacing: 6,
                    children: producteur.labels
                        .map((label) => Chip(
                              label: Text(label, style: LocalEatTypography.secondaire),
                              backgroundColor: LocalEatColors.surfaceGrise,
                              side: BorderSide.none,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
