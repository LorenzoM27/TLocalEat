import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../models/produit.dart';
import 'catalogue_viewmodel.dart';
import 'edition_produit_viewmodel.dart';

/// Route `/producteur/catalogue/:id` : charge le produit existant par son
/// id via ProduitRepository avant d'ouvrir le formulaire — évite que la
/// View ait à connaître la Data Source, comme toute autre View de l'app.
final _produitParIdProvider = FutureProvider.family<Produit?, String>((ref, id) async {
  final repo = ref.read(produitRepositoryProvider);
  return repo.getParId(id);
});

class EditionProduitParId extends ConsumerWidget {
  final String produitId;
  const EditionProduitParId({super.key, required this.produitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final produitAsync = ref.watch(_produitParIdProvider(produitId));
    return produitAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(color: LocalEatColors.vertPrincipal)),
      ),
      error: (err, _) => const Scaffold(body: Center(child: Text('Produit introuvable.'))),
      data: (produit) => EditionProduitView(produitExistant: produit),
    );
  }
}

class EditionProduitView extends ConsumerStatefulWidget {
  final Produit? produitExistant;
  const EditionProduitView({super.key, this.produitExistant});

  @override
  ConsumerState<EditionProduitView> createState() => _EditionProduitViewState();
}

class _EditionProduitViewState extends ConsumerState<EditionProduitView> {
  late final TextEditingController _nomController;
  late final TextEditingController _prixController;
  late final TextEditingController _pasController;
  late final TextEditingController _stockController;
  late final TextEditingController _seuilController;

  @override
  void initState() {
    super.initState();
    final produit = widget.produitExistant;
    _nomController = TextEditingController(text: produit?.nom ?? '');
    _prixController = TextEditingController(text: produit?.prixParUnite.toString() ?? '');
    _pasController = TextEditingController(text: produit?.pasQuantite.toString() ?? '100');
    _stockController = TextEditingController(text: produit?.stockDisponible.toString() ?? '');
    _seuilController = TextEditingController(text: produit?.seuilAlerteStock.toString() ?? '');
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prixController.dispose();
    _pasController.dispose();
    _stockController.dispose();
    _seuilController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = editionProduitViewModelProvider(widget.produitExistant);
    final produit = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);

    return Scaffold(
      backgroundColor: LocalEatColors.fondCasse,
      appBar: AppBar(
        backgroundColor: LocalEatColors.fondCasse,
        elevation: 0,
        title: Text(viewModel.estNouveau ? 'Nouveau produit' : 'Modifier le produit', style: LocalEatTypography.sousTitre),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(color: LocalEatColors.coral, borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 16),

            _Champ(label: 'Nom du produit', controller: _nomController, onChanged: viewModel.changerNom),
            const SizedBox(height: 10),

            const Text('Catégorie', style: LocalEatTypography.secondaire),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: produit.categorie,
              decoration: _decorationChamp(),
              items: const ['Légumes', 'Fruits', 'Épicerie', 'Fromages', 'Miel']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c, style: LocalEatTypography.corps)))
                  .toList(),
              onChanged: (valeur) {
                if (valeur != null) viewModel.changerCategorie(valeur);
              },
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _Champ(
                    label: 'Prix (€)',
                    controller: _prixController,
                    clavierNumerique: true,
                    onChanged: (v) => viewModel.changerPrix(double.tryParse(v) ?? 0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Unité', style: LocalEatTypography.secondaire),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<UniteProduit>(
                        value: produit.unite,
                        decoration: _decorationChamp(),
                        items: UniteProduit.values
                            .map((u) => DropdownMenuItem(value: u, child: Text(u.libelle, style: LocalEatTypography.corps)))
                            .toList(),
                        onChanged: (valeur) {
                          if (valeur != null) viewModel.changerUnite(valeur);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: LocalEatColors.surfaceGrise, borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.scale, size: 15, color: LocalEatColors.texteSecondaire),
                      SizedBox(width: 5),
                      Text('Vente par paliers', style: LocalEatTypography.secondaire),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _Champ(
                    label: 'Pas de quantité (en g, ou 1 pour une vente à la pièce)',
                    controller: _pasController,
                    clavierNumerique: true,
                    onChanged: (v) => viewModel.changerPasQuantite(int.tryParse(v) ?? 1),
                  ),
                  const SizedBox(height: 8),
                  _Champ(
                    label: 'Stock disponible',
                    controller: _stockController,
                    clavierNumerique: true,
                    onChanged: (v) => viewModel.changerStock(int.tryParse(v) ?? 0),
                  ),
                  const SizedBox(height: 8),
                  _Champ(
                    label: 'Seuil d\'alerte rupture',
                    controller: _seuilController,
                    clavierNumerique: true,
                    onChanged: (v) => viewModel.changerSeuilAlerte(int.tryParse(v) ?? 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Produit en vente', style: LocalEatTypography.corps),
                Switch(
                  value: produit.enVente,
                  activeColor: LocalEatColors.vertPrincipal,
                  onChanged: viewModel.changerEnVente,
                ),
              ],
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: LocalEatColors.vertPrincipal,
                foregroundColor: LocalEatColors.vertTresFonce,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () async {
                await viewModel.enregistrer();
                ref.invalidate(catalogueViewModelProvider);
                if (context.mounted) context.pop();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _decorationChamp() {
    return InputDecoration(
      filled: true,
      fillColor: LocalEatColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: LocalEatColors.bordure)),
    );
  }
}

class _Champ extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool clavierNumerique;

  const _Champ({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.clavierNumerique = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: LocalEatTypography.secondaire),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: clavierNumerique ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          style: LocalEatTypography.corps,
          decoration: InputDecoration(
            filled: true,
            fillColor: LocalEatColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: LocalEatColors.bordure)),
          ),
        ),
      ],
    );
  }
}
