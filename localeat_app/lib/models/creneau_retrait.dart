/// Model — créneau de retrait proposé par un producteur.
class CreneauRetrait {
  final String id;
  final String producteurId;
  final DateTime date;
  final String heureDebut; // format "HH:mm"
  final String heureFin;
  final int capaciteMax;
  final int nbCommandesReservees;

  const CreneauRetrait({
    required this.id,
    required this.producteurId,
    required this.date,
    required this.heureDebut,
    required this.heureFin,
    required this.capaciteMax,
    this.nbCommandesReservees = 0,
  });

  int get placesRestantes => capaciteMax - nbCommandesReservees;
  bool get complet => placesRestantes <= 0;

  String get libelle => '$heureDebut - $heureFin';
}
