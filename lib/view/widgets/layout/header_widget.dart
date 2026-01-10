import 'package:flutter/material.dart';
import '../../../const/constants.dart';
import '../../../services/cart_service.dart';
import '../../data/notifiers.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo avec animation
              _AnimatedLogo(),
              // Icône panier avec badge animé
              _AnimatedCartIcon(cartService: cartService),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedLogo extends StatefulWidget {
  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    ));

    _logoController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          selectedIndexNotifier.value = 0;
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Opacity(
                      opacity: _logoFadeAnimation.value,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor
                                  .withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.shopping_bag,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 14),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(20 * (1 - value), 0),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.secondaryColor,
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'Casalogy',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedCartIcon extends StatefulWidget {
  final CartService cartService;

  const _AnimatedCartIcon({required this.cartService});

  @override
  State<_AnimatedCartIcon> createState() => _AnimatedCartIconState();
}

class _AnimatedCartIconState extends State<_AnimatedCartIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _badgeController;
  int _previousItemCount = 0;

  @override
  void initState() {
    super.initState();
    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _badgeController.dispose();
    super.dispose();
  }

  void _animateBadge() {
    _badgeController.forward(from: 0.0).then((_) {
      _badgeController.reverse(from: 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.cartService.itemCountNotifier,
      builder: (context, itemCount, child) {
        // Animer le badge quand le nombre change
        if (itemCount != _previousItemCount && itemCount > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _animateBadge();
          });
          _previousItemCount = itemCount;
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              selectedIndexNotifier.value = 1;
            },
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: itemCount > 0
                    ? AppColors.primaryColor.withValues(alpha: 0.1)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: itemCount > 0
                      ? AppColors.primaryColor.withValues(alpha: 0.2)
                      : Colors.grey.shade200,
                  width: 1.5,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Icon(
                      Icons.shopping_cart_rounded,
                      key: ValueKey(itemCount > 0 ? 'filled' : 'empty'),
                      size: 26,
                      color: itemCount > 0
                          ? AppColors.primaryColor
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: AnimatedBuilder(
                        animation: _badgeController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_badgeController.value * 0.2),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.shade400,
                                    Colors.red.shade600,
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withValues(
                                      alpha: 0.4 + (_badgeController.value * 0.2),
                                    ),
                                    blurRadius: 6 + (_badgeController.value * 4),
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 22,
                                minHeight: 22,
                              ),
                              child: Center(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Text(
                                    itemCount > 99
                                        ? '99+'
                                        : itemCount.toString(),
                                    key: ValueKey(itemCount),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

