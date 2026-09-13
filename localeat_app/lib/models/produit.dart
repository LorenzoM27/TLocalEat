/// Unité de vente d'un produit, définie par le producteur.
enum UniteProduit { kg, piece, botte, litre }

extension UniteProduitLabel on UniteProduit {
  String get libelle {
    switch (this) {
      case UniteProduit.kg:
        return 'kg';
      case UniteProduit.piece:
        return 'pièce';
      case UniteProduit.botte:
        return 'botte';
      case UniteProduit.litre:
        return 'litre';
    }
  }
}

/// Model — entité métier pure, sans dépendance à Flutter ni au réseau.
///
/// Porte les règles de calcul de prix et de disponibilité, cohérentes avec
/// le modèle de données (modele-donnees-localeat.md) : le pas de quantité
/// et le stock disponible sont exprimés dans la même unité de base
/// (grammes pour un produit au kg, unités pour une vente à la pièce...).
class Produit {
  final String id;
  final String producteurId;
  final String nom;
  final String categorie;
  final double prixParUnite;
  final UniteProduit unite;

  /// Pas de quantité défini par le vendeur (ex. 100 g, ou 1 pour une vente
  /// à la pièce). Exprimé dans la même base que [stockDisponible].
  final int pasQuantite;

  /// Stock disponible, exprimé dans la même base que [pasQuantite].
  final int stockDisponible;

  /// Seuil sous lequel une alerte de stock faible est déclenchée.
  final int seuilAlerteStock;

  final bool enVente;
  final String? photoUrl;

  const Produit({
    required this.id,
    required this.producteurId,
    required this.nom,
    required this.categorie,
    required this.prixParUnite,
    required this.unite,
    required this.pasQuantite,
    required this.stockDisponible,
    required this.seuilAlerteStock,
    this.enVente = true,
    this.photoUrl,
  });

  bool get enRupture => stockDisponible <= 0;
  bool get stockFaible => stockDisponible > 0 && stockDisponible <= seuilAlerteStock;

  /// Calcule le prix pour une quantité donnée, exprimée dans la même base
  /// que [pasQuantite] (ex. en grammes pour un produit vendu au kg).
  ///
  /// Règle métier pure — testable sans mock, sans réseau, sans widget.
  double prixPour(int quantite) {
    if (unite == UniteProduit.piece || unite == UniteProduit.botte) {
      return quantite * prixParUnite;
    }
    // kg et litre : le prix est au kilo/litre, la quantité est en
    // grammes/millilitres.
    return (quantite / 1000) * prixParUnite;
  }

  /// La plus grande quantité atteignable par paliers sans dépasser le stock.
  int get quantiteMaxAchat {
    if (pasQuantite <= 0) return 0;
    return (stockDisponible ~/ pasQuantite) * pasQuantite;
  }

  Produit copierAvec({
    String? nom,
    String? categorie,
    double? prixParUnite,
    UniteProduit? unite,
    int? pasQuantite,
    int? stockDisponible,
    int? seuilAlerteStock,
    bool? enVente,
    String? photoUrl,
  }) {
    return Produit(
      id: id,
      producteurId: producteurId,
      nom: nom ?? this.nom,
      categorie: categorie ?? this.categorie,
      prixParUnite: prixParUnite ?? this.prixParUnite,
      unite: unite ?? this.unite,
      pasQuantite: pasQuantite ?? this.pasQuantite,
      stockDisponible: stockDisponible ?? this.stockDisponible,
      seuilAlerteStock: seuilAlerteStock ?? this.seuilAlerteStock,
      enVente: enVente ?? this.enVente,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
