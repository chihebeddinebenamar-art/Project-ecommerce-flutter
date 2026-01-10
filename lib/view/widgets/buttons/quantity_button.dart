import 'package:flutter/material.dart';
import '../../../const/constants.dart';

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const QuantityButton({
    super.key,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: onPressed != null ? AppColors.primaryColor : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}

