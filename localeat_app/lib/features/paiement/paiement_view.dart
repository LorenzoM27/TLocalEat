import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../panier/panier_viewmodel.dart';
import 'paiement_viewmodel.dart';

final _formatEuro = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

class PaiementView extends ConsumerWidget {
  const PaiementView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panier = ref.watch(panierProvider);
    final state = ref.watch(paiementViewModelProvider);
    final viewModel = ref.read(paiementViewModelProvider.notifier);

    ref.listen(paiementViewModelProvider, (avant, apres) {
      if (apres.statut == PaiementStatut.succes) {
        context.go('/confirmation');
      }
    });

    return Scaffold(
      backgroundColor: LocalEatColors.fondCasse,
      appBar: AppBar(
        backgroundColor: LocalEatColors.fondCasse,
        elevation: 0,
        title: const Text('Paiement', style: LocalEatTypography.sousTitre),
        iconTheme: const IconThemeData(color: LocalEatColors.texteFonce),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Paiement sécurisé', style: LocalEatTypography.sousTitre),
            const SizedBox(height: 16),
            _ChampFactice(label: 'Numéro de carte', valeur: '•••• •••• •••• 4242'),
            const SizedBox(height: 10),
            Row(
              children: const [
                Expanded(child: _ChampFactice(label: 'Expiration', valeur: '12/28')),
                SizedBox(width: 10),
                Expanded(child: _ChampFactice(label: 'CVC', valeur: '•••')),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Icon(Icons.lock_outline, size: 16, color: LocalEatColors.texteSecondaire),
                SizedBox(width: 6),
                Text('Paiement géré par Stripe', style: LocalEatTypography.secondaire),
              ],
            ),
            const Spacer(),
            if (state.messageErreur != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: LocalEatColors.danger.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  state.messageErreur!,
                  style: LocalEatTypography.secondaire.copyWith(color: LocalEatColors.danger),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: LocalEatTypography.sousTitre),
                Text(_formatEuro.format(panier.total), style: LocalEatTypography.prix),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: LocalEatColors.vertPrincipal,
                foregroundColor: LocalEatColors.vertTresFonce,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: state.statut == PaiementStatut.traitement
                  ? null
                  : () => viewModel.confirmerPaiement(panier),
              child: state.statut == PaiementStatut.traitement
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: LocalEatColors.vertTresFonce),
                    )
                  : const Text('Confirmer le paiement'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChampFactice extends StatelessWidget {
  final String label;
  final String valeur;
  const _ChampFactice({required this.label, required this.valeur});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: LocalEatTypography.secondaire),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: LocalEatColors.bordure),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(valeur, style: LocalEatTypography.corps.copyWith(color: LocalEatColors.texteMuted)),
        ),
      ],
    );
  }
}
