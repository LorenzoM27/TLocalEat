import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../models/producteur.dart';
import '../histoire_producteur/histoire_producteur_view.dart';
import '../panier/panier_viewmodel.dart';
import 'fiche_boutique_viewmodel.dart';
import 'widgets/carte_produit.dart';
import 'widgets/selecteur_quantite_view.dart';

final _formatEuro = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

class FicheBoutiqueView extends ConsumerWidget {
  final String producteurId;
  const FicheBoutiqueView({super.key, required this.producteurId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ficheBoutiqueViewModelProvider(producteurId));
    final viewModel = ref.read(ficheBoutiqueViewModelProvider(producteurId).notifier);
    final panier = ref.watch(panierProvider);

    if (state.chargement) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: LocalEatColors.vertPrincipal)),
      );
    }

    if (state.erreur != null || state.producteur == null) {
      return Scaffold(
        body: Center(child: Text(state.erreur ?? 'Boutique introuvable', style: LocalEatTypography.corps)),
      );
    }

    final producteur = state.producteur!;

    return Scaffold(
      backgroundColor: LocalEatColors.fondCasse,
      body: Column(
        children: [
          _EnTeteBoutique(
            producteur: producteur,
            estFavori: state.estFavori,
            onRetour: () => context.pop(),
            onFavori: viewModel.basculerFavori,
            onHistoire: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => HistoireProducteurView(producteur: producteur)),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    children: producteur.labels
                        .map((label) => Chip(
                              label: Text(label, style: LocalEatTypography.secondaire.copyWith(
                                color: LocalEatColors.vertTresFonce,
                                fontWeight: FontWeight.w600,
                              )),
                              backgroundColor: LocalEatColors.vertPrincipal,
                              side: BorderSide.none,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Produits disponibles', style: LocalEatTypography.secondaire),
                  const SizedBox(height: 8),
                  ...state.produits.map(
                    (produit) => CarteProduit(
                      produit: produit,
                      onAjouter: () => ouvrirSelecteurQuantite(context, produit),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!panier.estVide && panier.producteurId == producteurId)
            _BarrePanier(
              nombreArticles: panier.nombreArticles,
              total: panier.total,
              onTap: () => context.push('/panier'),
            ),
        ],
      ),
    );
  }
}

class _EnTeteBoutique extends StatelessWidget {
  final Producteur producteur;
  final bool estFavori;
  final VoidCallback onRetour;
  final VoidCallback onFavori;
  final VoidCallback onHistoire;

  const _EnTeteBoutique({
    required this.producteur,
    required this.estFavori,
    required this.onRetour,
    required this.onFavori,
    required this.onHistoire,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: LocalEatColors.vertPrincipal,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _BoutonCercle(icone: Icons.arrow_back, onTap: onRetour),
            const Spacer(),
            _BoutonCercle(
              icone: estFavori ? Icons.favorite : Icons.favorite_border,
              couleurIcone: LocalEatColors.coral,
              onTap: onFavori,
            ),
          ],
        ),
      ),
    );
  }
}

class _BoutonCercle extends StatelessWidget {
  final IconData icone;
  final Color? couleurIcone;
  final VoidCallback onTap;
  const _BoutonCercle({required this.icone, this.couleurIcone, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(icone, size: 18, color: couleurIcone ?? LocalEatColors.vertTresFonce),
      ),
    );
  }
}

class _BarrePanier extends StatelessWidget {
  final int nombreArticles;
  final double total;
  final VoidCallback onTap;
  const _BarrePanier({required this.nombreArticles, required this.total, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: LocalEatColors.vertPrincipal,
            foregroundColor: LocalEatColors.vertTresFonce,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: onTap,
          child: Text('Voir le panier · ${_formatEuro.format(total)}'),
        ),
      ),
    );
  }
}
