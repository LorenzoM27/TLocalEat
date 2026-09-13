import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../models/produit.dart';
import '../../panier/panier_viewmodel.dart';
import 'selecteur_quantite_viewmodel.dart';

final _formatEuro = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

/// Ouvre la feuille modale de sélection de quantité pour un produit donné.
/// Appelé depuis la fiche boutique au tap sur le bouton "+".
Future<void> ouvrirSelecteurQuantite(BuildContext context, Produit produit) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _SelecteurQuantiteSheet(produit: produit),
  );
}

class _SelecteurQuantiteSheet extends ConsumerWidget {
  final Produit produit;
  const _SelecteurQuantiteSheet({required this.produit});

  String _libelleQuantite(int quantite, Produit produit) {
    if (produit.unite == UniteProduit.piece || produit.unite == UniteProduit.botte) {
      final unite = produit.unite == UniteProduit.piece ? 'pièce(s)' : 'botte(s)';
      return '$quantite $unite';
    }
    if (produit.unite == UniteProduit.litre) {
      return quantite >= 1000 ? '${(quantite / 1000).toStringAsFixed(2)} L' : '$quantite mL';
    }
    // kg
    return quantite >= 1000 ? '${(quantite / 1000).toStringAsFixed(2)} kg' : '$quantite g';
  }

  List<int> _paliers(Produit produit) {
    final paliers = <int>[];
    for (var i = 1; i <= 4; i++) {
      final valeur = produit.pasQuantite * (i == 1 ? 1 : i * 2 - 1);
      if (valeur <= produit.quantiteMaxAchat) paliers.add(valeur);
    }
    if (paliers.isEmpty) paliers.add(produit.pasQuantite);
    return paliers.take(4).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantite = ref.watch(selecteurQuantiteViewModelProvider(produit));
    final viewModel = ref.read(selecteurQuantiteViewModelProvider(produit).notifier);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: LocalEatColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: LocalEatColors.bordure,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: LocalEatColors.coral,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(produit.nom, style: LocalEatTypography.sousTitre),
                    Text(
                      '${_formatEuro.format(produit.prixParUnite)} / ${produit.unite.libelle}',
                      style: LocalEatTypography.secondaire,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Quantité', style: LocalEatTypography.secondaire),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: LocalEatColors.surfaceGrise,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BoutonRond(
                    icone: Icons.remove,
                    actif: viewModel.peutDiminuer,
                    onTap: viewModel.diminuer,
                  ),
                  Text(_libelleQuantite(quantite, produit), style: LocalEatTypography.sousTitre),
                  _BoutonRond(
                    icone: Icons.add,
                    actif: viewModel.peutAugmenter,
                    onTap: viewModel.augmenter,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              children: _paliers(produit).map((palier) {
                final actif = palier == quantite;
                return GestureDetector(
                  onTap: () => viewModel.selectionnerPalier(palier),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: actif ? LocalEatColors.vertPrincipal : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: actif ? Colors.transparent : LocalEatColors.bordure,
                      ),
                    ),
                    child: Text(
                      _libelleQuantite(palier, produit),
                      style: LocalEatTypography.secondaire.copyWith(
                        color: actif ? LocalEatColors.vertTresFonce : LocalEatColors.texteFonce,
                        fontWeight: actif ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 28, color: LocalEatColors.bordure),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Sous-total', style: LocalEatTypography.secondaire),
                Text(_formatEuro.format(viewModel.prixTotal), style: LocalEatTypography.prix),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: LocalEatColors.vertPrincipal,
                foregroundColor: LocalEatColors.vertTresFonce,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: produit.enRupture
                  ? null
                  : () {
                      ref.read(panierProvider.notifier).ajouterOuMettreAJour(produit, quantite);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ajouté au panier')),
                      );
                    },
              child: const Text('Ajouter au panier'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoutonRond extends StatelessWidget {
  final IconData icone;
  final bool actif;
  final VoidCallback onTap;
  const _BoutonRond({required this.icone, required this.actif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: actif ? onTap : null,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: LocalEatColors.surface,
          border: Border.all(color: LocalEatColors.bordure),
        ),
        child: Icon(
          icone,
          size: 18,
          color: actif ? LocalEatColors.texteFonce : LocalEatColors.texteMuted,
        ),
      ),
    );
  }
}
