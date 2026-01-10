import 'package:flutter/material.dart';
import '../navigation/navbar_widget.dart';
import 'header_widget.dart';
import '../../data/notifiers.dart';
import '../../pages/home_page.dart';
import '../../pages/cart_page.dart';
import '../../pages/profile_page.dart';

List<Widget> pages = [const HomePage(), const CartPage(), const ProfilePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: selectedIndexNotifier,
              builder: (context, selectedIndex, child) {
                return pages.elementAt(selectedIndex);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }
}
