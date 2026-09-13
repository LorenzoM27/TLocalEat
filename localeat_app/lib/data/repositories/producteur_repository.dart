import '../mock_data.dart';
import '../../models/producteur.dart';

/// Interface consommée par les ViewModels — seule porte d'entrée vers les
/// données producteur, que la source soit l'API réelle ou (pour l'instant)
/// les données de démonstration en mémoire.
abstract class ProducteurRepository {
  Future<List<Producteur>> getProducteurs();
  Future<Producteur?> getParId(String id);
}

class ProducteurRepositoryMock implements ProducteurRepository {
  final _store = MockDataStore.instance;

  @override
  Future<List<Producteur>> getProducteurs() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_store.producteurs);
  }

  @override
  Future<Producteur?> getParId(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _store.producteurs.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
