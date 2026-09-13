import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../models/commande.dart';
import 'commandes_viewmodel.dart';

final _formatEuro = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

class CommandesProducteurView extends ConsumerWidget {
  const CommandesProducteurView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(commandesProducteurViewModelProvider);
    final viewModel = ref.read(commandesProducteurViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: LocalEatColors.fondCasse,
      appBar: AppBar(
        backgroundColor: LocalEatColors.fondCasse,
        elevation: 0,
        title: const Text('Commandes du jour', style: LocalEatTypography.sousTitre),
      ),
      body: state.chargement
          ? const Center(child: CircularProgressIndicator(color: LocalEatColors.vertPrincipal))
          : state.commandes.isEmpty
              ? const Center(child: Text('Aucune commande pour l\'instant.', style: LocalEatTypography.secondaire))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.commandes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final commande = state.commandes[index];
                    return _CarteCommande(
                      commande: commande,
                      onAvancer: () => viewModel.avancerStatut(commande.id, _statutSuivant(commande.statut)),
                    );
                  },
                ),
    );
  }

  StatutCommande _statutSuivant(StatutCommande statut) {
    switch (statut) {
      case StatutCommande.nouvelle:
        return StatutCommande.confirmee;
      case StatutCommande.confirmee:
        return StatutCommande.prete;
      case StatutCommande.prete:
        return StatutCommande.recuperee;
      default:
        return statut;
    }
  }
}

class _CarteCommande extends StatelessWidget {
  final Commande commande;
  final VoidCallback onAvancer;
  const _CarteCommande({required this.commande, required this.onAvancer});

  Color _couleurStatut(StatutCommande statut) {
    switch (statut) {
      case StatutCommande.nouvelle:
        return LocalEatColors.amber;
      case StatutCommande.confirmee:
        return LocalEatColors.vertPrincipal;
      case StatutCommande.prete:
        return LocalEatColors.vertPrincipal;
      case StatutCommande.recuperee:
        return LocalEatColors.texteMuted;
      case StatutCommande.annulee:
        return LocalEatColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final peutAvancer = commande.statut != StatutCommande.recuperee && commande.statut != StatutCommande.annulee;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: LocalEatColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LocalEatColors.bordure),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${commande.lignes.length} article(s) · ${commande.creneauLibelle}', style: LocalEatTypography.corps),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _couleurStatut(commande.statut).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  commande.statut.libelle,
                  style: LocalEatTypography.secondaire.copyWith(
                    color: _couleurStatut(commande.statut),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(_formatEuro.format(commande.montantTotal), style: LocalEatTypography.secondaire),
          if (peutAvancer) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: onAvancer, child: const Text('Faire avancer')),
            ),
          ],
        ],
      ),
    );
  }
}
