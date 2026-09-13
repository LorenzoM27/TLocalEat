# LocalEat — squelette Flutter (MVVM)

Squelette d'application fonctionnel pour LocalEat, développé selon l'architecture décrite dans
`spec-technique-mvvm-localeat.md`. Ce projet n'a **pas été compilé ni exécuté** dans cet environnement
(le SDK Flutter n'y est pas installé) — il a été écrit directement à partir de la spec, en suivant scrupuleusement
les conventions Dart/Flutter. Une relecture manuelle a été faite, mais il est possible que `flutter pub get`
ou `flutter analyze` remontent un ou deux ajustements mineurs (import oublié, typo) à corriger en local.

## Ce qui est implémenté

- **Architecture MVVM complète** : Model (`lib/models/`), Repositories + Data Sources mock (`lib/data/`),
  ViewModels et Views organisés par écran (`lib/features/`), conformément à la structure de dossiers de la spec.
- **Parcours particulier complet** : Carte (liste filtrable, pas de vraie carte géographique — voir
  "Ce qui manque" ci-dessous) → Fiche boutique (photos, bouton favori, accès à l'histoire du producteur) →
  Sélecteur de quantité par palier (calcul de prix en temps réel) → Panier (choix du créneau) → Paiement
  (formulaire factice, logique de revérification du stock) → Confirmation.
- **Parcours producteur** : Catalogue avec CRUD produit (y compris les champs pas de quantité, stock,
  seuil d'alerte), liste des commandes avec changement de statut.
- **Favoris**, avec bouton cœur synchronisé entre la fiche boutique et l'espace favoris.
- **Règles métier testées** : `test/models/produit_test.dart` couvre le calcul de prix par palier et les
  règles de stock, en tests unitaires purs (aucun mock, aucun widget) — comme préconisé dans la spec.
- **Données de démonstration en mémoire** (`lib/data/mock_data.dart`) : aucune API n'existe encore, donc
  les Repositories simulent des appels réseau (délai artificiel inclus) sur un jeu de données fixe.

## Ce qui manque pour un vrai MVP

1. **Le backend réel.** Toute la couche `data/repositories/` utilise des implémentations `*Mock` qui
   lisent/écrivent en mémoire. Il faut écrire les implémentations réelles (`ProduitRepositoryApi`, etc.)
   qui appellent les endpoints de `spec-api-localeat.md` via `dio`, et les brancher dans `lib/app/providers.dart`
   — c'est le seul fichier à modifier, aucune View ni ViewModel n'a besoin de changer.
2. **Une vraie carte géographique.** L'écran Carte affiche une liste filtrable, pas une carte interactive
   avec pins — il faut intégrer `google_maps_flutter` ou `flutter_map` (voir décision à trancher, spec MVVM section 11).
3. **L'authentification.** Aucun écran de connexion/inscription n'existe ; `producteurConnecteId` est une
   constante en dur (`lib/features/espace_producteur/catalogue/catalogue_viewmodel.dart`).
4. **Stripe réel.** L'écran de paiement est un formulaire factice — `flutter_stripe` n'est pas intégré.
5. **Écrans non couverts** : onboarding producteur multi-étapes, messagerie, avis/notation, back-office admin,
   notifications push.
6. **Assets réels** : aucune image/logo n'est fournie ; les blocs colorés remplacent les photos produits.

## Lancer le projet en local

```bash
flutter pub get
flutter run
flutter test        # lance test/models/produit_test.dart
```

## Correspondance avec les documents de cadrage

| Document | Ce qu'il couvre dans ce code |
|---|---|
| `cahier-des-charges-localeat-v0.2.md` | Vision produit, périmètre fonctionnel — sert de référence pour prioriser ce qu'il reste à coder |
| `spec-technique-mvvm-localeat.md` | Structure de dossiers, découpage Model/View/ViewModel suivi ici à la lettre |
| `modele-donnees-localeat.md` | À utiliser pour écrire le vrai backend et les DTOs de désérialisation JSON |
| `spec-api-localeat.md` | À utiliser pour écrire les implémentations `*RepositoryApi` qui remplaceront les mocks |
