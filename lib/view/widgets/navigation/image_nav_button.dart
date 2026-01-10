import 'package:flutter/material.dart';
import '../../../const/constants.dart';

class ImageNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const ImageNavButton({
    super.key,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.textPrimary),
        onPressed: onPressed,
      ),
    );
  }
}

