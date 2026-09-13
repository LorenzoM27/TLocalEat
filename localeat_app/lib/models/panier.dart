import 'produit.dart';

/// Une ligne du panier : un produit + la quantité choisie via le
/// sélecteur de quantité par palier.
class LignePanier {
  final Produit produit;
  final int quantite; // exprimée dans la même base que produit.pasQuantite

  const LignePanier({required this.produit, required this.quantite});

  double get sousTotal => produit.prixPour(quantite);

  LignePanier copierAvec({int? quantite}) {
    return LignePanier(produit: produit, quantite: quantite ?? this.quantite);
  }
}

/// Model — panier local, mono-producteur (décision prise en section 4.5
/// du cahier des charges pour le MVP : un panier par producteur).
class Panier {
  final String? producteurId;
  final List<LignePanier> lignes;
  final String? creneauRetraitId;

  const Panier({
    this.producteurId,
    this.lignes = const [],
    this.creneauRetraitId,
  });

  bool get estVide => lignes.isEmpty;

  double get total => lignes.fold(0, (somme, ligne) => somme + ligne.sousTotal);

  int get nombreArticles => lignes.length;

  Panier ajouterOuMettreAJour(Produit produit, int quantite) {
    // Panier mono-producteur : si on ajoute un produit d'un autre
    // producteur, on repart d'un panier vide pour ce nouveau producteur.
    final memePro = producteurId == null || producteurId == produit.producteurId;
    final lignesDeBase = memePro ? lignes : <LignePanier>[];

    final index = lignesDeBase.indexWhere((l) => l.produit.id == produit.id);
    final nouvellesLignes = List<LignePanier>.from(lignesDeBase);
    if (index >= 0) {
      nouvellesLignes[index] = nouvellesLignes[index].copierAvec(quantite: quantite);
    } else {
      nouvellesLignes.add(LignePanier(produit: produit, quantite: quantite));
    }

    return Panier(
      producteurId: produit.producteurId,
      lignes: nouvellesLignes,
      creneauRetraitId: memePro ? creneauRetraitId : null,
    );
  }

  Panier retirer(String produitId) {
    final nouvellesLignes = lignes.where((l) => l.produit.id != produitId).toList();
    return Panier(
      producteurId: nouvellesLignes.isEmpty ? null : producteurId,
      lignes: nouvellesLignes,
      creneauRetraitId: nouvellesLignes.isEmpty ? null : creneauRetraitId,
    );
  }

  Panier avecCreneau(String creneauId) {
    return Panier(producteurId: producteurId, lignes: lignes, creneauRetraitId: creneauId);
  }

  static const Panier vide = Panier();
}
