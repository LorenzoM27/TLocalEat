import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../models/commande.dart';
import '../catalogue/catalogue_viewmodel.dart';

class CommandesProducteurState {
  final bool chargement;
  final List<Commande> commandes;
  const CommandesProducteurState({this.chargement = true, this.commandes = const []});
}

class CommandesProducteurViewModel extends StateNotifier<CommandesProducteurState> {
  final Ref ref;
  CommandesProducteurViewModel(this.ref) : super(const CommandesProducteurState()) {
    charger();
  }

  Future<void> charger() async {
    state = const CommandesProducteurState(chargement: true);
    final repo = ref.read(commandeRepositoryProvider);
    final commandes = await repo.getParProducteur(producteurConnecteId);
    state = CommandesProducteurState(chargement: false, commandes: commandes);
  }

  Future<void> avancerStatut(String commandeId, StatutCommande nouveauStatut) async {
    final repo = ref.read(commandeRepositoryProvider);
    await repo.mettreAJourStatut(commandeId, nouveauStatut);
    await charger();
  }
}

final commandesProducteurViewModelProvider =
    StateNotifierProvider<CommandesProducteurViewModel, CommandesProducteurState>((ref) {
  return CommandesProducteurViewModel(ref);
});
