import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/providers.dart';
import '../../../models/produit.dart';
import 'catalogue_viewmodel.dart';

/// ViewModel du formulaire produit — porte l'état d'un brouillon de
/// [Produit] et sait le sauvegarder (création ou modification) via
/// ProduitRepository, sans jamais connaître l'API HTTP sous-jacente.
class EditionProduitViewModel extends StateNotifier<Produit> {
  final Ref ref;
  final bool estNouveau;
  static const _uuid = Uuid();

  EditionProduitViewModel(this.ref, Produit? produitExistant)
      : estNouveau = produitExistant == null,
        super(produitExistant ??
            Produit(
              id: _uuid.v4(),
              producteurId: producteurConnecteId,
              nom: '',
              categorie: 'Légumes',
              prixParUnite: 0,
              unite: UniteProduit.kg,
              pasQuantite: 100,
              stockDisponible: 0,
              seuilAlerteStock: 0,
            ));

  void changerNom(String nom) => state = state.copierAvec(nom: nom);
  void changerCategorie(String categorie) => state = state.copierAvec(categorie: categorie);
  void changerPrix(double prix) => state = state.copierAvec(prixParUnite: prix);
  void changerUnite(UniteProduit unite) => state = state.copierAvec(unite: unite);
  void changerPasQuantite(int pas) => state = state.copierAvec(pasQuantite: pas);
  void changerStock(int stock) => state = state.copierAvec(stockDisponible: stock);
  void changerSeuilAlerte(int seuil) => state = state.copierAvec(seuilAlerteStock: seuil);
  void changerEnVente(bool enVente) => state = state.copierAvec(enVente: enVente);

  Future<void> enregistrer() async {
    final repo = ref.read(produitRepositoryProvider);
    if (estNouveau) {
      await repo.creer(state);
    } else {
      await repo.modifier(state);
    }
  }
}

final editionProduitViewModelProvider =
    StateNotifierProvider.family<EditionProduitViewModel, Produit, Produit?>((ref, produitExistant) {
  return EditionProduitViewModel(ref, produitExistant);
});
