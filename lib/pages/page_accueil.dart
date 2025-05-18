// page_accueil.dart (Thème Star Wars)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../modeles/post.dart';
import '../services_firebase/service_firestore.dart';
import '../widgets/widget_vide.dart'; // Assurez-vous que ce widget est adapté au thème sombre
import '../widgets/widget_post.dart';

class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key, required this.title});
  final String title;
  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  @override
  Widget build(BuildContext context) {
    // Accède au thème actuel
    final theme = Theme.of(context);

    return Scaffold(
      // Le fond du Scaffold utilisera la couleur 'background' du thème
        appBar: AppBar(
          // Utilise la couleur 'surface' ou 'darkBackgroundColor' du thème pour l'AppBar
          // 'inversePrimary' peut ne pas correspondre au thème Star Wars
          backgroundColor: theme.colorScheme.surface, // Ou theme.colorScheme.background si tu préfères
          title: Text(widget.title),
          // Le style du titre est géré par appBarTheme dans star_wars_theme.dart
          // La couleur des icônes (comme le bouton de retour si présent) est gérée par appBarTheme
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: ServiceFirestore().allPosts(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                // L'indicateur de chargement utilisera la couleur 'primary' du thème
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              );
            }

            if (snapshot.hasError) {
              print("Erreur Firestore: ${snapshot.error}");
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Une erreur s'est produite lors du chargement des posts. Veuillez réessayer plus tard.",
                    textAlign: TextAlign.center,
                    // Utilise la couleur 'error' du thème pour les messages d'erreur
                    style: TextStyle(color: theme.colorScheme.error, fontSize: 16),
                  ),
                ),
              );
            }

            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
                // Assure-toi que EmptyBody est adapté au thème sombre
                return const EmptyBody();
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final post = Post(
                    reference: doc.reference,
                    id: doc.id,
                    map: doc.data() as Map<String, dynamic>,
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    // WidgetPost devrait également s'adapter au thème via le CardTheme et TextTheme
                    child: WidgetPost(post: post),
                  );
                },
              );
            } else {
              // Ce cas devrait être couvert par ConnectionState.waiting ou hasError,
              // mais au cas où :
              return const EmptyBody();
            }
          },
        ));
  }
}
