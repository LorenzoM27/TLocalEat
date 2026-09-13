import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../models/creneau_retrait.dart';
import 'creneau_provider.dart';
import 'panier_viewmodel.dart';

final _formatEuro = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

class PanierView extends ConsumerWidget {
  const PanierView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panier = ref.watch(panierProvider);
    final panierNotifier = ref.read(panierProvider.notifier);

    if (panier.estVide) {
      return Scaffold(
        appBar: AppBar(title: const Text('Votre commande')),
        body: const Center(child: Text('Votre panier est vide.', style: LocalEatTypography.corps)),
      );
    }

    final creneauxAsync = ref.watch(creneauxDisponiblesProvider(panier.producteurId!));

    return Scaffold(
      backgroundColor: LocalEatColors.fondCasse,
      appBar: AppBar(
        backgroundColor: LocalEatColors.fondCasse,
        elevation: 0,
        title: const Text('Votre commande', style: LocalEatTypography.sousTitre),
        iconTheme: const IconThemeData(color: LocalEatColors.texteFonce),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ...panier.lignes.map(
                  (ligne) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: LocalEatColors.coral,
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${ligne.produit.nom}',
                            style: LocalEatTypography.corps,
                          ),
                        ),
                        Text(_formatEuro.format(ligne.sousTotal), style: LocalEatTypography.corps),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16, color: LocalEatColors.texteMuted),
                          onPressed: () => panierNotifier.retirer(ligne.produit.id),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(color: LocalEatColors.bordure),
                const SizedBox(height: 8),
                const Text('Créneau de retrait', style: LocalEatTypography.secondaire),
                const SizedBox(height: 8),
                creneauxAsync.when(
                  loading: () => const CircularProgressIndicator(color: LocalEatColors.vertPrincipal),
                  error: (err, _) => const Text('Impossible de charger les créneaux.', style: LocalEatTypography.secondaire),
                  data: (creneaux) => Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: creneaux.map((creneau) {
                      final actif = creneau.id == panier.creneauRetraitId;
                      return _ChipCreneau(
                        creneau: creneau,
                        actif: actif,
                        onTap: creneau.complet ? null : () => panierNotifier.choisirCreneau(creneau.id),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: LocalEatTypography.sousTitre),
                      Text(_formatEuro.format(panier.total), style: LocalEatTypography.prix),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LocalEatColors.vertPrincipal,
                      foregroundColor: LocalEatColors.vertTresFonce,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: panier.creneauRetraitId == null ? null : () => context.push('/paiement'),
                    child: const Text('Payer et confirmer'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipCreneau extends StatelessWidget {
  final CreneauRetrait creneau;
  final bool actif;
  final VoidCallback? onTap;
  const _ChipCreneau({required this.creneau, required this.actif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: actif
              ? LocalEatColors.vertPrincipal
              : creneau.complet
                  ? LocalEatColors.surfaceGrise
                  : LocalEatColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: actif ? Colors.transparent : LocalEatColors.bordure),
        ),
        child: Text(
          creneau.complet ? '${creneau.libelle} · complet' : creneau.libelle,
          style: LocalEatTypography.secondaire.copyWith(
            color: actif
                ? LocalEatColors.vertTresFonce
                : creneau.complet
                    ? LocalEatColors.texteMuted
                    : LocalEatColors.texteFonce,
            fontWeight: actif ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
