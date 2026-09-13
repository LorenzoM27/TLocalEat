/// Model — fiche producteur (boutique + exploitation), cohérent avec les
/// tables `producteurs` / `exploitations` du modèle de données.
class Producteur {
  final String id;
  final String nomBoutique;
  final String? description;
  final String? histoire;
  final String? methodeProduction;
  final int? anneeCreationExploitation;
  final String? photoCouvertureUrl;
  final List<String> labels;
  final double latitude;
  final double longitude;
  final String adresse;

  const Producteur({
    required this.id,
    required this.nomBoutique,
    this.description,
    this.histoire,
    this.methodeProduction,
    this.anneeCreationExploitation,
    this.photoCouvertureUrl,
    this.labels = const [],
    required this.latitude,
    required this.longitude,
    required this.adresse,
  });

  /// Distance approximative (en mètres) à un point donné, formule
  /// haversine simplifiée — suffisante pour un tri d'affichage côté app ;
  /// la vraie recherche de proximité est faite côté API via PostGIS.
  double distanceApproxMetres(double lat, double lng) {
    const rayonTerreKm = 6371.0;
    final dLat = _versRadians(latitude - lat);
    final dLng = _versRadians(longitude - lng);
    final a = (dLat / 2).abs() * (dLat / 2).abs() +
        (dLng / 2).abs() * (dLng / 2).abs();
    final c = 2 * a.clamp(0, 1);
    return rayonTerreKm * c * 1000;
  }

  double _versRadians(double degres) => degres * 3.1415926535 / 180;
}
