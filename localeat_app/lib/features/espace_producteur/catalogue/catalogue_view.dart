import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../models/produit.dart';
import 'catalogue_viewmodel.dart';

final _formatEuro = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

class CatalogueView extends ConsumerWidget {
  const CatalogueView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogueViewModelProvider);

    return Scaffold(
      backgroundColor: LocalEatColors.fondCasse,
      appBar: AppBar(
        backgroundColor: LocalEatColors.fondCasse,
        elevation: 0,
        title: const Text('Mes produits', style: LocalEatTypography.sousTitre),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: LocalEatColors.vertPrincipal,
        foregroundColor: LocalEatColors.vertTresFonce,
        onPressed: () => context.push('/producteur/catalogue/nouveau'),
        child: const Icon(Icons.add),
      ),
      body: state.chargement
          ? const Center(child: CircularProgressIndicator(color: LocalEatColors.vertPrincipal))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.produits.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final produit = state.produits[index];
                return _LigneProduit(produit: produit);
              },
            ),
    );
  }
}

class _LigneProduit extends StatelessWidget {
  final Produit produit;
  const _LigneProduit({required this.produit});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.push('/producteur/catalogue/${produit.id}'),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: LocalEatColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: LocalEatColors.bordure),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: LocalEatColors.coral, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(produit.nom, style: LocalEatTypography.corps.copyWith(fontWeight: FontWeight.w500)),
                  Text(
                    produit.enRupture
                        ? 'Rupture de stock'
                        : 'Stock : ${produit.stockDisponible} · ${_formatEuro.format(produit.prixParUnite)}/${produit.unite.libelle}',
                    style: LocalEatTypography.secondaire.copyWith(
                      color: produit.enRupture ? LocalEatColors.danger : LocalEatColors.texteSecondaire,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit, size: 16, color: LocalEatColors.texteMuted),
          ],
        ),
      ),
    );
  }
}
