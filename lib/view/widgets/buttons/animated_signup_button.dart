import 'package:flutter/material.dart';
import '../../../const/constants.dart';

class AnimatedSignupButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const AnimatedSignupButton({
    super.key,
    required this.onTap,
    required this.isLoading,
  });

  @override
  State<AnimatedSignupButton> createState() => _AnimatedSignupButtonState();
}

class _AnimatedSignupButtonState extends State<AnimatedSignupButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isLoading ? 1.0 : _pulseAnimation.value,
          child: Container(
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
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isLoading ? null : widget.onTap,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  alignment: Alignment.center,
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'S\'inscrire',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

