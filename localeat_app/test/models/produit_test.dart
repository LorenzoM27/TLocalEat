import 'package:flutter_test/flutter_test.dart';
import 'package:localeat/models/produit.dart';

void main() {
  group('Produit.prixPour', () {
    test('calcule le prix proportionnellement pour un produit vendu au kg', () {
      const produit = Produit(
        id: 'p1',
        producteurId: 'prod-1',
        nom: 'Tomates anciennes',
        categorie: 'Légumes',
        prixParUnite: 3.50,
        unite: UniteProduit.kg,
        pasQuantite: 100,
        stockDisponible: 12000,
        seuilAlerteStock: 2000,
      );

      // 300 g à 3,50 €/kg => 1,05 €
      expect(produit.prixPour(300), closeTo(1.05, 0.001));
      // 1000 g => le prix au kilo exact
      expect(produit.prixPour(1000), closeTo(3.50, 0.001));
    });

    test('calcule le prix à l\'unité pour un produit vendu à la pièce', () {
      const produit = Produit(
        id: 'p2',
        producteurId: 'prod-1',
        nom: 'Pot de miel',
        categorie: 'Épicerie',
        prixParUnite: 8.50,
        unite: UniteProduit.piece,
        pasQuantite: 1,
        stockDisponible: 24,
        seuilAlerteStock: 5,
      );

      expect(produit.prixPour(1), closeTo(8.50, 0.001));
      expect(produit.prixPour(3), closeTo(25.50, 0.001));
    });
  });

  group('Produit — règles de stock', () {
    test('enRupture est vrai quand le stock est à zéro', () {
      const produit = Produit(
        id: 'p3',
        producteurId: 'prod-1',
        nom: 'Miel toutes fleurs',
        categorie: 'Épicerie',
        prixParUnite: 6.00,
        unite: UniteProduit.piece,
        pasQuantite: 1,
        stockDisponible: 0,
        seuilAlerteStock: 3,
      );

      expect(produit.enRupture, isTrue);
      expect(produit.stockFaible, isFalse);
    });

    test('stockFaible est vrai sous le seuil d\'alerte, sans être en rupture', () {
      const produit = Produit(
        id: 'p4',
        producteurId: 'prod-1',
        nom: 'Courgettes',
        categorie: 'Légumes',
        prixParUnite: 2.20,
        unite: UniteProduit.kg,
        pasQuantite: 100,
        stockDisponible: 800,
        seuilAlerteStock: 1000,
      );

      expect(produit.stockFaible, isTrue);
      expect(produit.enRupture, isFalse);
    });

    test('quantiteMaxAchat ne dépasse jamais le stock disponible et respecte le pas', () {
      const produit = Produit(
        id: 'p5',
        producteurId: 'prod-1',
        nom: 'Tomates anciennes',
        categorie: 'Légumes',
        prixParUnite: 3.50,
        unite: UniteProduit.kg,
        pasQuantite: 100,
        stockDisponible: 250, // ne tombe pas juste sur un multiple de 100
        seuilAlerteStock: 50,
      );

      // 250 g de stock avec un pas de 100 g => 200 g maximum achetables
      expect(produit.quantiteMaxAchat, 200);
    });
  });
}
