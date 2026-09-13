import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../models/producteur.dart';
import '../../models/produit.dart';

class FicheBoutiqueState {
  final bool chargement;
  final Producteur? producteur;
  final List<Produit> produits;
  final bool estFavori;
  final String? erreur;

  const FicheBoutiqueState({
    this.chargement = true,
    this.producteur,
    this.produits = const [],
    this.estFavori = false,
    this.erreur,
  });

  FicheBoutiqueState copierAvec({
    bool? chargement,
    Producteur? producteur,
    List<Produit>? produits,
    bool? estFavori,
    String? erreur,
  }) {
    return FicheBoutiqueState(
      chargement: chargement ?? this.chargement,
      producteur: producteur ?? this.producteur,
      produits: produits ?? this.produits,
      estFavori: estFavori ?? this.estFavori,
      erreur: erreur,
    );
  }
}

class FicheBoutiqueViewModel extends StateNotifier<FicheBoutiqueState> {
  final Ref ref;
  final String producteurId;

  FicheBoutiqueViewModel(this.ref, this.producteurId) : super(const FicheBoutiqueState()) {
    charger();
  }

  Future<void> charger() async {
    state = state.copierAvec(chargement: true, erreur: null);
    try {
      final producteurRepo = ref.read(producteurRepositoryProvider);
      final produitRepo = ref.read(produitRepositoryProvider);
      final favorisRepo = ref.read(favorisRepositoryProvider);

      final producteur = await producteurRepo.getParId(producteurId);
      final produits = await produitRepo.getProduitsParProducteur(producteurId);
      final favoris = await favorisRepo.getFavorisIds();

      state = state.copierAvec(
        chargement: false,
        producteur: producteur,
        produits: produits,
        estFavori: favoris.contains(producteurId),
      );
    } catch (e) {
      state = state.copierAvec(chargement: false, erreur: 'Impossible de charger la boutique.');
    }
  }

  Future<void> basculerFavori() async {
    final favorisRepo = ref.read(favorisRepositoryProvider);
    final nouvelEtat = !state.estFavori;
    state = state.copierAvec(estFavori: nouvelEtat);
    if (nouvelEtat) {
      await favorisRepo.ajouter(producteurId);
    } else {
      await favorisRepo.retirer(producteurId);
    }
  }
}

final ficheBoutiqueViewModelProvider = StateNotifierProvider.family<
    FicheBoutiqueViewModel, FicheBoutiqueState, String>((ref, producteurId) {
  return FicheBoutiqueViewModel(ref, producteurId);
});
