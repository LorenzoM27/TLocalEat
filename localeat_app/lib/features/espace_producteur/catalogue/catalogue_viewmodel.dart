import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../models/produit.dart';

/// Identifiant du producteur connecté — en dur pour l'instant, en
/// attendant l'authentification réelle (voir spec-api-localeat.md, section 3).
const String producteurConnecteId = 'prod-1';

class CatalogueState {
  final bool chargement;
  final List<Produit> produits;
  const CatalogueState({this.chargement = true, this.produits = const []});
}

class CatalogueViewModel extends StateNotifier<CatalogueState> {
  final Ref ref;
  CatalogueViewModel(this.ref) : super(const CatalogueState()) {
    charger();
  }

  Future<void> charger() async {
    state = const CatalogueState(chargement: true);
    final repo = ref.read(produitRepositoryProvider);
    final produits = await repo.getProduitsParProducteur(producteurConnecteId);
    state = CatalogueState(chargement: false, produits: produits);
  }

  Future<void> supprimer(String produitId) async {
    final repo = ref.read(produitRepositoryProvider);
    await repo.supprimer(produitId);
    await charger();
  }
}

final catalogueViewModelProvider = StateNotifierProvider<CatalogueViewModel, CatalogueState>((ref) {
  return CatalogueViewModel(ref);
});
