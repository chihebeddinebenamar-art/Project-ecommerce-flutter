import 'package:flutter/material.dart';
import '../../const/constants.dart';
import '../widgets/backgrounds/particle_background.dart';
import '../widgets/buttons/animated_login_button.dart';
import 'login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _gradientController;
  late AnimationController _logoController;
  late AnimationController _textController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _gradientAnimation;
  late Animation<double> _logoRotation;
  late Animation<double> _logoScale;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Contrôleur principal
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Contrôleur pour le gradient animé
    _gradientController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    // Contrôleur pour le logo
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Contrôleur pour le texte
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _gradientController,
        curve: Curves.easeInOut,
      ),
    );

    _logoRotation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeInOut,
      ),
    );

    _logoScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeInOut,
      ),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    // Démarrer les animations
    _mainAnimationController.forward();
    _textController.forward();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _gradientController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    AppColors.backgroundGradient.colors[0],
                    AppColors.backgroundGradientAlt.colors[0],
                    _gradientAnimation.value,
                  )!,
                  Color.lerp(
                    AppColors.backgroundGradient.colors[1],
                    AppColors.backgroundGradientAlt.colors[1],
                    _gradientAnimation.value,
                  )!,
                  Color.lerp(
                    AppColors.backgroundGradient.colors[2],
                    AppColors.backgroundGradientAlt.colors[2],
                    _gradientAnimation.value,
                  )!,
                  Color.lerp(
                    AppColors.backgroundGradient.colors[3],
                    AppColors.backgroundGradientAlt.colors[3],
                    _gradientAnimation.value,
                  )!,
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
            child: ParticleBackground(
              particleCount: 15,
              child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo avec animations multiples
                            AnimatedBuilder(
                              animation: _logoController,
                              builder: (context, child) {
                                return TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.elasticOut,
                                  builder: (context, value, child) {
                                    return Transform.rotate(
                                      angle: _logoRotation.value,
                                      child: Transform.scale(
                                        scale: value * _logoScale.value,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 40.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.primaryColor.withValues(alpha: 0.3 * value),
                                                blurRadius: 30,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20.0),
                                            child: Image.asset(
                                              'assets/images/logo.png',
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 30),

                            // Texte de bienvenue avec animation
                            AnimatedBuilder(
                              animation: _textAnimation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _textAnimation.value,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - _textAnimation.value)),
                                    child: Column(
                                      children: [
                                        ShaderMask(
                                          shaderCallback: (bounds) => LinearGradient(
                                            colors: [
                                              AppColors.textPrimary,
                                              AppColors.textAccent,
                                            ],
                                          ).createShader(bounds),
                                          child: Text(
                                            'Bienvenue',
                                            style: textStyles.welcomeTitleStyle.copyWith(
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Découvrez notre collection exclusive\nde casaques de qualité',
                                          style: textStyles.welcomeSubtitleStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 60),

                            // Bouton Login avec animations avancées
                            AnimatedLoginButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        const LoginPage(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0.0, 0.1),
                                            end: Offset.zero,
                                          ).animate(CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOutCubic,
                                          )),
                                          child: child,
                                        ),
                                      );
                                    },
                                    transitionDuration: const Duration(milliseconds: 400),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          );
        },
      ),
    );
  }
}
