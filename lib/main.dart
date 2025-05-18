import 'package:chti_face_bouc/star_wars_style.dart';

import './pages/page_authentification.dart';
import './pages/page_navigation.dart';

import 'pages/page_accueil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chti Face bouc',
      theme: starWarsTheme,
      debugShowCheckedModeBanner: false,
      home: const PageAuthentification(),
    );
  }
}
