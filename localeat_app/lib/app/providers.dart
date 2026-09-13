import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/commande_repository.dart';
import '../data/repositories/creneau_repository.dart';
import '../data/repositories/favoris_repository.dart';
import '../data/repositories/producteur_repository.dart';
import '../data/repositories/produit_repository.dart';

/// Chaque provider expose une interface de Repository — pas son
/// implémentation concrète. Le jour où l'API réelle (spec-api-localeat.md)
/// est prête, seule la ligne `=> XxxRepositoryMock()` change ici, dans
/// toute l'app : aucun ViewModel n'a besoin d'être touché.

final producteurRepositoryProvider = Provider<ProducteurRepository>((ref) {
  return ProducteurRepositoryMock();
});

final produitRepositoryProvider = Provider<ProduitRepository>((ref) {
  return ProduitRepositoryMock();
});

final creneauRepositoryProvider = Provider<CreneauRepository>((ref) {
  return CreneauRepositoryMock();
});

final commandeRepositoryProvider = Provider<CommandeRepository>((ref) {
  return CommandeRepositoryMock();
});

final favorisRepositoryProvider = Provider<FavorisRepository>((ref) {
  return FavorisRepositoryMock();
});
