enum StatutCommande { nouvelle, confirmee, prete, recuperee, annulee }

extension StatutCommandeLabel on StatutCommande {
  String get libelle {
    switch (this) {
      case StatutCommande.nouvelle:
        return 'Nouvelle';
      case StatutCommande.confirmee:
        return 'Confirmée';
      case StatutCommande.prete:
        return 'Prête';
      case StatutCommande.recuperee:
        return 'Récupérée';
      case StatutCommande.annulee:
        return 'Annulée';
    }
  }
}

class LigneCommande {
  final String produitNom;
  final int quantite;
  final double prixUnitaireSnapshot;
  final double sousTotal;

  const LigneCommande({
    required this.produitNom,
    required this.quantite,
    required this.prixUnitaireSnapshot,
    required this.sousTotal,
  });
}

/// Model — commande passée par un particulier chez un producteur.
///
/// `prixUnitaireSnapshot` sur chaque ligne fige le prix au moment de
/// l'achat, indépendamment d'une évolution ultérieure du catalogue
/// (cf. modele-donnees-localeat.md, section 6).
class Commande {
  final String id;
  final String producteurId;
  final String nomProducteur;
  final String creneauLibelle;
  final List<LigneCommande> lignes;
  final double montantTotal;
  final StatutCommande statut;
  final DateTime dateCreation;

  const Commande({
    required this.id,
    required this.producteurId,
    required this.nomProducteur,
    required this.creneauLibelle,
    required this.lignes,
    required this.montantTotal,
    required this.statut,
    required this.dateCreation,
  });

  Commande avecStatut(StatutCommande nouveauStatut) {
    return Commande(
      id: id,
      producteurId: producteurId,
      nomProducteur: nomProducteur,
      creneauLibelle: creneauLibelle,
      lignes: lignes,
      montantTotal: montantTotal,
      statut: nouveauStatut,
      dateCreation: dateCreation,
    );
  }
}
