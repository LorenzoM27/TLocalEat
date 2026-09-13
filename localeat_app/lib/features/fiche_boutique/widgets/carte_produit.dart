import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../models/produit.dart';

final _formatEuro = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

/// Widget — purement affichage, aucune logique. `onAjouter` est fourni par
/// la View parente (qui ouvre le sélecteur de quantité).
class CarteProduit extends StatelessWidget {
  final Produit produit;
  final VoidCallback? onAjouter;

  const CarteProduit({super.key, required this.produit, required this.onAjouter});

  @override
  Widget build(BuildContext context) {
    final indisponible = produit.enRupture || !produit.enVente;

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: LocalEatColors.surfaceGrise,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Opacity(
        opacity: indisponible ? 0.5 : 1,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: LocalEatColors.coral,
                borderRadius: BorderRadius.circular(10),
                image: produit.photoUrl != null
                    ? DecorationImage(image: NetworkImage(produit.photoUrl!), fit: BoxFit.cover)
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(produit.nom, style: LocalEatTypography.corps.copyWith(fontWeight: FontWeight.w500)),
                  Text(
                    indisponible
                        ? 'Rupture de stock'
                        : '${_formatEuro.format(produit.prixParUnite)} / ${produit.unite.libelle}'
                            '${produit.stockFaible ? ' · derniers dispos' : ''}',
                    style: LocalEatTypography.secondaire,
                  ),
                ],
              ),
            ),
            if (!indisponible)
              GestureDetector(
                onTap: onAjouter,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: LocalEatColors.bordure),
                  ),
                  child: const Icon(Icons.add, size: 16, color: LocalEatColors.texteSecondaire),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
