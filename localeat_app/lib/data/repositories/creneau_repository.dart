import '../mock_data.dart';
import '../../models/creneau_retrait.dart';

abstract class CreneauRepository {
  Future<List<CreneauRetrait>> getParProducteur(String producteurId);
  Future<bool> reserverPlace(String creneauId);
}

class CreneauRepositoryMock implements CreneauRepository {
  final _store = MockDataStore.instance;

  @override
  Future<List<CreneauRetrait>> getParProducteur(String producteurId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(
      _store.creneaux.where((c) => c.producteurId == producteurId),
    );
  }

  @override
  Future<bool> reserverPlace(String creneauId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _store.creneaux.indexWhere((c) => c.id == creneauId);
    if (index < 0) return false;
    final creneau = _store.creneaux[index];
    if (creneau.complet) return false;
    _store.creneaux[index] = CreneauRetrait(
      id: creneau.id,
      producteurId: creneau.producteurId,
      date: creneau.date,
      heureDebut: creneau.heureDebut,
      heureFin: creneau.heureFin,
      capaciteMax: creneau.capaciteMax,
      nbCommandesReservees: creneau.nbCommandesReservees + 1,
    );
    return true;
  }
}
