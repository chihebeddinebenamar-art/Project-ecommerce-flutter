import 'package:flutter/material.dart';
import '../../../const/constants.dart';

class AnimatedLoginButton extends StatefulWidget {
  final VoidCallback onTap;

  const AnimatedLoginButton({super.key, required this.onTap});

  @override
  State<AnimatedLoginButton> createState() => _AnimatedLoginButtonState();
}

class _AnimatedLoginButtonState extends State<AnimatedLoginButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // Contrôleur pour l'effet de pulsation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Contrôleur pour l'effet shimmer
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _scaleAnimation,
          _pulseAnimation,
          _shimmerAnimation,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value * _pulseAnimation.value,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.4),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: AppColors.secondaryColor.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Effet shimmer
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedBuilder(
                        animation: _shimmerAnimation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: ShimmerPainter(
                              progress: _shimmerAnimation.value,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Texte
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Peintre pour l'effet shimmer
class ShimmerPainter extends CustomPainter {
  final double progress;

  ShimmerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      begin: Alignment(-1.0 + progress, 0.0),
      end: Alignment(progress, 0.0),
      colors: [
        Colors.transparent,
        Colors.white.withValues(alpha: 0.3),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

