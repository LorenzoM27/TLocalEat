import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/carte/carte_view.dart';
import '../features/espace_producteur/accueil_producteur_view.dart';
import '../features/espace_producteur/catalogue/catalogue_view.dart';
import '../features/espace_producteur/catalogue/edition_produit_view.dart';
import '../features/espace_producteur/commandes/commandes_view.dart';
import '../features/favoris/favoris_view.dart';
import '../features/fiche_boutique/fiche_boutique_view.dart';
import '../features/paiement/confirmation_view.dart';
import '../features/paiement/paiement_view.dart';
import '../features/panier/panier_view.dart';
import '../features/profil_particulier/profil_view.dart';
import 'shell_particulier.dart';

/// Router déclaratif — reflète l'arborescence définie au cahier des
/// charges (section 7.3) : Carte, Fiche boutique, Panier, Paiement côté
/// particulier ; Catalogue et Commandes côté producteur.
final routerLocalEat = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellParticulier(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const CarteView()),
        GoRoute(path: '/favoris', builder: (context, state) => const FavorisView()),
        GoRoute(path: '/profil', builder: (context, state) => const ProfilView()),
      ],
    ),
    GoRoute(
      path: '/boutique/:id',
      builder: (context, state) => FicheBoutiqueView(producteurId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/panier', builder: (context, state) => const PanierView()),
    GoRoute(path: '/paiement', builder: (context, state) => const PaiementView()),
    GoRoute(path: '/confirmation', builder: (context, state) => const ConfirmationView()),

    // Espace producteur
    GoRoute(path: '/producteur', builder: (context, state) => const AccueilProducteurView()),
    GoRoute(path: '/producteur/commandes', builder: (context, state) => const CommandesProducteurView()),
    GoRoute(path: '/producteur/catalogue', builder: (context, state) => const CatalogueView()),
    GoRoute(
      path: '/producteur/catalogue/nouveau',
      builder: (context, state) => const EditionProduitView(),
    ),
    GoRoute(
      path: '/producteur/catalogue/:id',
      builder: (context, state) => EditionProduitParId(produitId: state.pathParameters['id']!),
    ),
  ],
);
