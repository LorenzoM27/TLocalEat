import '../models/commande.dart';
import '../models/creneau_retrait.dart';
import '../models/producteur.dart';
import '../models/produit.dart';

/// Données de démonstration en mémoire.
///
/// Tient lieu de base de données le temps que le backend (spec-api-localeat.md)
/// soit implémenté. Les Repositories sont les seuls à connaître cette classe :
/// le jour où l'API existe, seuls les fichiers de `data/repositories/`
/// changent — aucune View ni ViewModel n'a besoin d'être modifié.
class MockDataStore {
  MockDataStore._interne();
  static final MockDataStore instance = MockDataStore._interne();

  final List<Producteur> producteurs = [
    const Producteur(
      id: 'prod-1',
      nomBoutique: 'Ferme de Marc',
      description: 'Maraîcher bio en plein cœur de la vallée.',
      histoire:
          'Exploitation familiale transmise de père en fils depuis 1998. '
          'Culture en pleine terre, sans pesticides, certifiée AB depuis 2015.',
      methodeProduction: 'Culture en pleine terre, sans pesticides',
      anneeCreationExploitation: 1998,
      labels: ['Bio', '3e génération'],
      latitude: 48.8566,
      longitude: 2.3522,
      adresse: '12 chemin des Maraîchers',
    ),
    const Producteur(
      id: 'prod-2',
      nomBoutique: 'Rucher des Collines',
      description: 'Miels et produits de la ruche, en circuit court.',
      histoire: 'Apiculteur depuis 10 ans, une trentaine de ruches réparties sur trois communes.',
      methodeProduction: 'Apiculture raisonnée, sans traitement chimique',
      anneeCreationExploitation: 2015,
      labels: ['Local'],
      latitude: 48.8606,
      longitude: 2.3376,
      adresse: '4 route des Collines',
    ),
  ];

  final List<Produit> produits = [
    const Produit(
      id: 'produit-1',
      producteurId: 'prod-1',
      nom: 'Tomates anciennes',
      categorie: 'Légumes',
      prixParUnite: 3.50,
      unite: UniteProduit.kg,
      pasQuantite: 100,
      stockDisponible: 12000,
      seuilAlerteStock: 2000,
    ),
    const Produit(
      id: 'produit-2',
      producteurId: 'prod-1',
      nom: 'Courgettes',
      categorie: 'Légumes',
      prixParUnite: 2.20,
      unite: UniteProduit.kg,
      pasQuantite: 100,
      stockDisponible: 8000,
      seuilAlerteStock: 1500,
    ),
    const Produit(
      id: 'produit-3',
      producteurId: 'prod-1',
      nom: 'Miel toutes fleurs',
      categorie: 'Épicerie',
      prixParUnite: 6.00,
      unite: UniteProduit.piece,
      pasQuantite: 1,
      stockDisponible: 0,
      seuilAlerteStock: 3,
    ),
    const Produit(
      id: 'produit-4',
      producteurId: 'prod-2',
      nom: 'Pot de miel 500g',
      categorie: 'Épicerie',
      prixParUnite: 8.50,
      unite: UniteProduit.piece,
      pasQuantite: 1,
      stockDisponible: 24,
      seuilAlerteStock: 5,
    ),
  ];

  final List<CreneauRetrait> creneaux = [
    CreneauRetrait(
      id: 'creneau-1',
      producteurId: 'prod-1',
      date: DateTime.now(),
      heureDebut: '16:00',
      heureFin: '17:00',
      capaciteMax: 8,
      nbCommandesReservees: 5,
    ),
    CreneauRetrait(
      id: 'creneau-2',
      producteurId: 'prod-1',
      date: DateTime.now(),
      heureDebut: '17:00',
      heureFin: '18:00',
      capaciteMax: 8,
      nbCommandesReservees: 2,
    ),
    CreneauRetrait(
      id: 'creneau-3',
      producteurId: 'prod-2',
      date: DateTime.now(),
      heureDebut: '10:00',
      heureFin: '12:00',
      capaciteMax: 10,
      nbCommandesReservees: 1,
    ),
  ];

  final List<Commande> commandes = [];

  final Set<String> favoris = {};
}
