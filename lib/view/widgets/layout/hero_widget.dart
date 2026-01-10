import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../const/constants.dart';

class HeroWidget extends StatelessWidget {
  final String title;
  const HeroWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: title,
      child: Column(
        children: [
          Text(title, style: textStyles.titleStyle.copyWith(fontSize: 24)),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Lottie.asset(
              'assets/lotties/loading.json',
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
            ),
          ),
        ],
      ),
    );
  }
}
