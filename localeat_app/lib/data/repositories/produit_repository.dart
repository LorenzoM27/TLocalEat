import '../mock_data.dart';
import '../../models/produit.dart';

abstract class ProduitRepository {
  Future<List<Produit>> getProduitsParProducteur(String producteurId);
  Future<Produit?> getParId(String id);
  Future<Produit> creer(Produit produit);
  Future<Produit> modifier(Produit produit);
  Future<void> supprimer(String produitId);

  /// Décrémente le stock de manière atomique. Renvoie `false` si le stock
  /// restant est insuffisant — mime côté client la même vérification que
  /// fera l'API en base (voir spec-api-localeat.md, section 7).
  Future<bool> decrementerStock(String produitId, int quantite);
}

class ProduitRepositoryMock implements ProduitRepository {
  final _store = MockDataStore.instance;

  @override
  Future<List<Produit>> getProduitsParProducteur(String producteurId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(
      _store.produits.where((p) => p.producteurId == producteurId),
    );
  }

  @override
  Future<Produit?> getParId(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _store.produits.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Produit> creer(Produit produit) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _store.produits.add(produit);
    return produit;
  }

  @override
  Future<Produit> modifier(Produit produit) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _store.produits.indexWhere((p) => p.id == produit.id);
    if (index >= 0) {
      _store.produits[index] = produit;
    }
    return produit;
  }

  @override
  Future<void> supprimer(String produitId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _store.produits.removeWhere((p) => p.id == produitId);
  }

  @override
  Future<bool> decrementerStock(String produitId, int quantite) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _store.produits.indexWhere((p) => p.id == produitId);
    if (index < 0) return false;
    final produit = _store.produits[index];
    if (produit.stockDisponible < quantite) return false;
    _store.produits[index] = produit.copierAvec(
      stockDisponible: produit.stockDisponible - quantite,
    );
    return true;
  }
}
