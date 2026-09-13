import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/panier.dart';
import '../../models/produit.dart';

/// ViewModel exposé globalement : le panier doit être accessible aussi bien
/// depuis la fiche boutique (ajout d'un produit) que depuis l'écran panier
/// et l'écran de paiement.
class PanierNotifier extends StateNotifier<Panier> {
  PanierNotifier() : super(Panier.vide);

  void ajouterOuMettreAJour(Produit produit, int quantite) {
    state = state.ajouterOuMettreAJour(produit, quantite);
  }

  void retirer(String produitId) {
    state = state.retirer(produitId);
  }

  void choisirCreneau(String creneauId) {
    state = state.avecCreneau(creneauId);
  }

  void vider() {
    state = Panier.vide;
  }
}

final panierProvider = StateNotifierProvider<PanierNotifier, Panier>((ref) {
  return PanierNotifier();
});
