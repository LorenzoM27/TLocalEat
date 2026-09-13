import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../models/producteur.dart';

class FavorisState {
  final bool chargement;
  final List<Producteur> producteurs;
  const FavorisState({this.chargement = true, this.producteurs = const []});
}

class FavorisViewModel extends StateNotifier<FavorisState> {
  final Ref ref;
  FavorisViewModel(this.ref) : super(const FavorisState()) {
    charger();
  }

  Future<void> charger() async {
    final favorisRepo = ref.read(favorisRepositoryProvider);
    final producteurRepo = ref.read(producteurRepositoryProvider);

    final ids = await favorisRepo.getFavorisIds();
    final tous = await producteurRepo.getProducteurs();
    final favoris = tous.where((p) => ids.contains(p.id)).toList();

    state = FavorisState(chargement: false, producteurs: favoris);
  }

  Future<void> retirer(String producteurId) async {
    final favorisRepo = ref.read(favorisRepositoryProvider);
    await favorisRepo.retirer(producteurId);
    await charger();
  }
}

final favorisViewModelProvider = StateNotifierProvider<FavorisViewModel, FavorisState>((ref) {
  return FavorisViewModel(ref);
});
