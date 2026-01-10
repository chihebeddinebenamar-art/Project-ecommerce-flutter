import 'package:flutter/material.dart';
import '../../data/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedIndexNotifier,
      builder: (context, selectedIndex, child) {
        return NavigationBar(
          destinations: [
            const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            const NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Panier'),
            const NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          ],
          onDestinationSelected: (int value) {
            selectedIndexNotifier.value = value;
          },
          selectedIndex: selectedIndex,
        );
      },
    );
  }
}
