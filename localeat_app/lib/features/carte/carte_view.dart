import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../models/producteur.dart';
import 'carte_viewmodel.dart';

/// View — purement déclarative : elle affiche l'état exposé par
/// [CarteViewModel] et ne contient aucune logique métier.
class CarteView extends ConsumerWidget {
  const CarteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(carteViewModelProvider);
    final viewModel = ref.read(carteViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: LocalEatColors.fondCasse,
      body: SafeArea(
        child: Column(
          children: [
            _EnTeteCarte(),
            _BarreDeRecherche(onChanged: viewModel.changerRecherche),
            _ChipsFiltres(
              filtreBioActif: state.filtreBioUniquement,
              onToggleBio: viewModel.basculerFiltreBio,
            ),
            Expanded(
              child: state.chargement
                  ? const Center(child: CircularProgressIndicator(color: LocalEatColors.vertPrincipal))
                  : state.erreur != null
                      ? _MessageErreur(message: state.erreur!, onReessayer: viewModel.charger)
                      : _ListeProducteurs(producteurs: state.producteursFiltres),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnTeteCarte extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: LocalEatColors.vertPrincipal,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          const SizedBox(width: 8),
          const Text('LocalEat', style: LocalEatTypography.sousTitre),
          const Spacer(),
          const Icon(Icons.notifications_none, color: LocalEatColors.texteSecondaire),
        ],
      ),
    );
  }
}

class _BarreDeRecherche extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _BarreDeRecherche({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Producteur ou produit',
          hintStyle: LocalEatTypography.secondaire,
          prefixIcon: const Icon(Icons.search, color: LocalEatColors.texteMuted),
          filled: true,
          fillColor: LocalEatColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _ChipsFiltres extends StatelessWidget {
  final bool filtreBioActif;
  final VoidCallback onToggleBio;
  const _ChipsFiltres({required this.filtreBioActif, required this.onToggleBio});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _Chip(label: 'Bio', actif: filtreBioActif, onTap: onToggleBio),
          const SizedBox(width: 6),
          const _Chip(label: 'Aujourd\'hui', actif: false, onTap: null),
          const SizedBox(width: 6),
          const _Chip(label: '5 km', actif: false, onTap: null),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool actif;
  final VoidCallback? onTap;
  const _Chip({required this.label, required this.actif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: actif ? LocalEatColors.vertPrincipal : LocalEatColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: actif ? Colors.transparent : LocalEatColors.bordure),
        ),
        child: Text(
          label,
          style: LocalEatTypography.secondaire.copyWith(
            color: actif ? LocalEatColors.vertTresFonce : LocalEatColors.texteFonce,
            fontWeight: actif ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _ListeProducteurs extends StatelessWidget {
  final List<Producteur> producteurs;
  const _ListeProducteurs({required this.producteurs});

  @override
  Widget build(BuildContext context) {
    if (producteurs.isEmpty) {
      return const Center(
        child: Text('Aucun producteur ne correspond à votre recherche.', style: LocalEatTypography.secondaire),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: producteurs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final producteur = producteurs[index];
        return _CarteProducteur(producteur: producteur);
      },
    );
  }
}

class _CarteProducteur extends StatelessWidget {
  final Producteur producteur;
  const _CarteProducteur({required this.producteur});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/boutique/${producteur.id}'),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: LocalEatColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: LocalEatColors.bordure),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: LocalEatColors.vertPrincipal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.eco, color: LocalEatColors.vertTresFonce),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(producteur.nomBoutique, style: LocalEatTypography.sousTitre),
                  const SizedBox(height: 2),
                  Text(producteur.labels.join(' · '), style: LocalEatTypography.secondaire),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: LocalEatColors.texteMuted),
          ],
        ),
      ),
    );
  }
}

class _MessageErreur extends StatelessWidget {
  final String message;
  final VoidCallback onReessayer;
  const _MessageErreur({required this.message, required this.onReessayer});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: LocalEatTypography.corps, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton(onPressed: onReessayer, child: const Text('Réessayer')),
        ],
      ),
    );
  }
}
