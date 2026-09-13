import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import 'favoris_viewmodel.dart';

class FavorisView extends ConsumerWidget {
  const FavorisView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favorisViewModelProvider);
    final viewModel = ref.read(favorisViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: LocalEatColors.fondCasse,
      appBar: AppBar(
        backgroundColor: LocalEatColors.fondCasse,
        elevation: 0,
        title: const Text('Favoris', style: LocalEatTypography.sousTitre),
      ),
      body: state.chargement
          ? const Center(child: CircularProgressIndicator(color: LocalEatColors.vertPrincipal))
          : state.producteurs.isEmpty
              ? const Center(child: Text('Aucun producteur favori pour l\'instant.', style: LocalEatTypography.secondaire))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.producteurs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final producteur = state.producteurs[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: LocalEatColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: LocalEatColors.bordure),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.push('/boutique/${producteur.id}'),
                              child: Text(producteur.nomBoutique, style: LocalEatTypography.corps),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite, color: LocalEatColors.coral, size: 20),
                            onPressed: () => viewModel.retirer(producteur.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
