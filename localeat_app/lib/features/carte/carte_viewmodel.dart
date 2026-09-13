import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../models/producteur.dart';

class CarteState {
  final bool chargement;
  final List<Producteur> producteurs;
  final String recherche;
  final bool filtreBioUniquement;
  final String? erreur;

  const CarteState({
    this.chargement = true,
    this.producteurs = const [],
    this.recherche = '',
    this.filtreBioUniquement = false,
    this.erreur,
  });

  List<Producteur> get producteursFiltres {
    return producteurs.where((p) {
      final matchRecherche = recherche.isEmpty ||
          p.nomBoutique.toLowerCase().contains(recherche.toLowerCase());
      final matchBio = !filtreBioUniquement || p.labels.contains('Bio');
      return matchRecherche && matchBio;
    }).toList();
  }

  CarteState copierAvec({
    bool? chargement,
    List<Producteur>? producteurs,
    String? recherche,
    bool? filtreBioUniquement,
    String? erreur,
  }) {
    return CarteState(
      chargement: chargement ?? this.chargement,
      producteurs: producteurs ?? this.producteurs,
      recherche: recherche ?? this.recherche,
      filtreBioUniquement: filtreBioUniquement ?? this.filtreBioUniquement,
      erreur: erreur,
    );
  }
}

/// ViewModel de l'écran carte — ne connaît que le ProducteurRepository,
/// jamais l'API HTTP ni la source de données sous-jacente.
class CarteViewModel extends StateNotifier<CarteState> {
  final Ref ref;

  CarteViewModel(this.ref) : super(const CarteState()) {
    charger();
  }

  Future<void> charger() async {
    state = state.copierAvec(chargement: true, erreur: null);
    try {
      final repo = ref.read(producteurRepositoryProvider);
      final producteurs = await repo.getProducteurs();
      state = state.copierAvec(chargement: false, producteurs: producteurs);
    } catch (e) {
      state = state.copierAvec(chargement: false, erreur: 'Impossible de charger les producteurs.');
    }
  }

  void changerRecherche(String texte) {
    state = state.copierAvec(recherche: texte);
  }

  void basculerFiltreBio() {
    state = state.copierAvec(filtreBioUniquement: !state.filtreBioUniquement);
  }
}

final carteViewModelProvider = StateNotifierProvider<CarteViewModel, CarteState>((ref) {
  return CarteViewModel(ref);
});
