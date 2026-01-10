import 'package:flutter/material.dart';

// Couleurs du projet web
class AppColors {
  // Couleurs principales du web
  static const Color primaryColor = Color(0xFF667eea); // #667eea
  static const Color secondaryColor = Color(0xFF764ba2); // #764ba2
  static const Color accentColor = Color(0xFFbb86fc); // #bb86fc
  static const Color backgroundColor = Color(0xFF0f2027); //rgb(189, 221, 235)
  static const Color backgroundColor2 = Color(0xFF203a43); // #203a43
  static const Color backgroundColor3 = Color(0xFF2c5364); // #2c5364
  
  // Gradient pour les boutons 
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
  );
  
  // Gradient pour le background (moderne et attrayant)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE8F4F8), // Bleu très clair
      Color(0xFFF0E8F5), // Violet très clair
      Color(0xFFE8F0F8), // Bleu clair
      Color(0xFFF5F0E8), // Beige clair
    ],
    stops: [0.0, 0.3, 0.6, 1.0],
  );
  
  // Gradient alternatif pour animations
  static const LinearGradient backgroundGradientAlt = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFFF0E8F5), // Violet très clair
      Color(0xFFE8F4F8), // Bleu très clair
      Color(0xFFF5F0E8), // Beige clair
      Color(0xFFE8F0F8), // Bleu clair
    ],
    stops: [0.0, 0.3, 0.6, 1.0],
  );
  
  // Couleur de texte pour fond clair
  static const Color textPrimary = Color(0xFF1A1A2E); // Bleu foncé
  static const Color textSecondary = Color(0xFF4A5568); // Gris bleuté
  static const Color textAccent = Color(0xFF667eea); // Violet-bleu
}

class textStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle descriptionStyle = TextStyle(
    fontSize: 16.0,
    color: Colors.white70,
  );
  
  static const TextStyle welcomeTitleStyle = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );
  
  static const TextStyle welcomeSubtitleStyle = TextStyle(
    fontSize: 18.0,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.5,
  );
}
