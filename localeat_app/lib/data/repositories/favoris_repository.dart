import '../mock_data.dart';

abstract class FavorisRepository {
  Future<Set<String>> getFavorisIds();
  Future<void> ajouter(String producteurId);
  Future<void> retirer(String producteurId);
}

class FavorisRepositoryMock implements FavorisRepository {
  final _store = MockDataStore.instance;

  @override
  Future<Set<String>> getFavorisIds() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return Set.unmodifiable(_store.favoris);
  }

  @override
  Future<void> ajouter(String producteurId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _store.favoris.add(producteurId);
  }

  @override
  Future<void> retirer(String producteurId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _store.favoris.remove(producteurId);
  }
}
