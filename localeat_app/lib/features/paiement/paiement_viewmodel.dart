import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../models/commande.dart';
import '../../models/panier.dart';
import '../panier/panier_viewmodel.dart';

enum PaiementStatut { pret, traitement, succes, stockInsuffisant, erreur }

class PaiementState {
  final PaiementStatut statut;
  final Commande? commande;
  final String? messageErreur;

  const PaiementState({this.statut = PaiementStatut.pret, this.commande, this.messageErreur});
}

/// Reproduit côté client la logique transactionnelle décrite dans
/// spec-api-localeat.md (section 7 et 8) : on revérifie le stock juste
/// avant de "payer", pour ne jamais valider une commande sur un stock
/// qui a pu changer entre-temps. Le vrai appel Stripe/webhook sera fait
/// côté backend — ici, on simule le succès du paiement.
class PaiementViewModel extends StateNotifier<PaiementState> {
  final Ref ref;

  PaiementViewModel(this.ref) : super(const PaiementState());

  Future<void> confirmerPaiement(Panier panier) async {
    state = const PaiementState(statut: PaiementStatut.traitement);

    final produitRepo = ref.read(produitRepositoryProvider);
    final creneauRepo = ref.read(creneauRepositoryProvider);
    final commandeRepo = ref.read(commandeRepositoryProvider);
    final producteurRepo = ref.read(producteurRepositoryProvider);

    // 1. Revérifier et décrémenter le stock de chaque ligne, atomiquement.
    for (final ligne in panier.lignes) {
      final ok = await produitRepo.decrementerStock(ligne.produit.id, ligne.quantite);
      if (!ok) {
        state = PaiementState(
          statut: PaiementStatut.stockInsuffisant,
          messageErreur: 'Il ne reste plus assez de "${ligne.produit.nom}" disponible.',
        );
        return;
      }
    }

    // 2. Réserver une place sur le créneau choisi.
    final creneauOk = await creneauRepo.reserverPlace(panier.creneauRetraitId!);
    if (!creneauOk) {
      state = const PaiementState(
        statut: PaiementStatut.erreur,
        messageErreur: 'Ce créneau vient d\'être complété. Merci d\'en choisir un autre.',
      );
      return;
    }

    // 3. Créer la commande (le paiement Stripe réel se brancherait ici).
    final producteur = await producteurRepo.getParId(panier.producteurId!);
    final creneaux = await creneauRepo.getParProducteur(panier.producteurId!);
    final creneau = creneaux.firstWhere((c) => c.id == panier.creneauRetraitId);

    final commande = await commandeRepo.creerDepuisPanier(panier, producteur!, creneau.libelle);

    ref.read(panierProvider.notifier).vider();
    state = PaiementState(statut: PaiementStatut.succes, commande: commande);
  }
}

final paiementViewModelProvider = StateNotifierProvider<PaiementViewModel, PaiementState>((ref) {
  return PaiementViewModel(ref);
});
