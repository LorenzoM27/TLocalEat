import 'package:flutter/material.dart';
import 'colors.dart';

/// Typographie ronde et lisible, cohérente avec l'identité "nature, frais, local"
/// définie dans le cahier des charges (section 7.1).
class LocalEatTypography {
  LocalEatTypography._();

  static const String fontFamily = 'Roboto';

  static const TextStyle titre = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: LocalEatColors.texteFonce,
  );

  static const TextStyle sousTitre = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: LocalEatColors.texteFonce,
  );

  static const TextStyle corps = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: LocalEatColors.texteFonce,
    height: 1.5,
  );

  static const TextStyle secondaire = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: LocalEatColors.texteSecondaire,
  );

  static const TextStyle prix = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: LocalEatColors.texteFonce,
  );
}
