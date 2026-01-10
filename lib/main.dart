import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'view/widgets/layout/widget_tree.dart';
import 'view/pages/welcome_page.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 
  try {
    
    Firebase.app();
    debugPrint('Firebase already initialized');
  } catch (e) {
    
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('Firebase initialized successfully');
    } catch (initError) {
      
      if (initError.toString().contains('duplicate-app')) {
        debugPrint('Firebase already initialized (duplicate-app error caught)');
      } else {
        debugPrint('Firebase initialization error: $initError');
        rethrow;
      }
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return const WidgetTree();
          }
          return const WelcomePage();
        },
      ),
    );
  }
}
