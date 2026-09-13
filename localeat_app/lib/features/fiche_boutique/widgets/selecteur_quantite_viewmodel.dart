import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/produit.dart';

/// ViewModel isolé du sélecteur de quantité : aucune dépendance réseau,
/// juste le Model Produit et ses règles de calcul de prix (voir
/// produit.dart, prixPour() et quantiteMaxAchat).
class SelecteurQuantiteViewModel extends StateNotifier<int> {
  final Produit produit;

  SelecteurQuantiteViewModel(this.produit)
      : super(_valeurParDefaut(produit));

  static int _valeurParDefaut(Produit produit) {
    final defaut = produit.pasQuantite * 3;
    return defaut > produit.quantiteMaxAchat ? produit.pasQuantite : defaut;
  }

  int get quantite => state;
  double get prixTotal => produit.prixPour(state);
  bool get peutAugmenter => state + produit.pasQuantite <= produit.quantiteMaxAchat;
  bool get peutDiminuer => state - produit.pasQuantite >= produit.pasQuantite;

  void augmenter() {
    if (!peutAugmenter) return;
    state += produit.pasQuantite;
  }

  void diminuer() {
    if (!peutDiminuer) return;
    state -= produit.pasQuantite;
  }

  void selectionnerPalier(int quantite) {
    if (quantite > produit.quantiteMaxAchat) return;
    state = quantite;
  }
}

final selecteurQuantiteViewModelProvider = StateNotifierProvider.family<
    SelecteurQuantiteViewModel, int, Produit>((ref, produit) {
  return SelecteurQuantiteViewModel(produit);
});
