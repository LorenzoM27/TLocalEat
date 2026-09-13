import 'package:uuid/uuid.dart';

import '../mock_data.dart';
import '../../models/commande.dart';
import '../../models/panier.dart';
import '../../models/producteur.dart';

abstract class CommandeRepository {
  /// Crée une commande à partir d'un panier. Reproduit côté client la
  /// logique transactionnelle décrite dans spec-api-localeat.md
  /// (section 7) : le décrément de stock est fait par ProduitRepository
  /// avant l'appel à cette méthode par le ViewModel appelant.
  Future<Commande> creerDepuisPanier(Panier panier, Producteur producteur, String creneauLibelle);

  Future<List<Commande>> getParProducteur(String producteurId);
  Future<Commande> mettreAJourStatut(String commandeId, StatutCommande statut);
}

class CommandeRepositoryMock implements CommandeRepository {
  final _store = MockDataStore.instance;
  final _uuid = const Uuid();

  @override
  Future<Commande> creerDepuisPanier(
    Panier panier,
    Producteur producteur,
    String creneauLibelle,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final lignes = panier.lignes
        .map((l) => LigneCommande(
              produitNom: l.produit.nom,
              quantite: l.quantite,
              prixUnitaireSnapshot: l.produit.prixParUnite,
              sousTotal: l.sousTotal,
            ))
        .toList();

    final commande = Commande(
      id: _uuid.v4(),
      producteurId: producteur.id,
      nomProducteur: producteur.nomBoutique,
      creneauLibelle: creneauLibelle,
      lignes: lignes,
      montantTotal: panier.total,
      statut: StatutCommande.nouvelle,
      dateCreation: DateTime.now(),
    );

    _store.commandes.insert(0, commande);
    return commande;
  }

  @override
  Future<List<Commande>> getParProducteur(String producteurId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(
      _store.commandes.where((c) => c.producteurId == producteurId),
    );
  }

  @override
  Future<Commande> mettreAJourStatut(String commandeId, StatutCommande statut) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _store.commandes.indexWhere((c) => c.id == commandeId);
    final miseAJour = _store.commandes[index].avecStatut(statut);
    _store.commandes[index] = miseAJour;
    return miseAJour;
  }
}
