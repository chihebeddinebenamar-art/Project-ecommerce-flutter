import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/notifiers.dart';
import 'welcome_page.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        title: const Text('Logout'),
        leading: const Icon(Icons.logout),
        onTap: () {
          FirebaseAuth.instance.signOut();
          selectedIndexNotifier.value = 0;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return WelcomePage();
              },
            ),
          );
        },
      ),
    );
  }
}
