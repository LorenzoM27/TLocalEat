import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../models/creneau_retrait.dart';

final creneauxDisponiblesProvider =
    FutureProvider.family<List<CreneauRetrait>, String>((ref, producteurId) async {
  final repo = ref.read(creneauRepositoryProvider);
  return repo.getParProducteur(producteurId);
});
