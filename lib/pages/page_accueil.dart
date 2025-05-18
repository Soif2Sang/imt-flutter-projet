// page_accueil.dart (MODIFIÉ)
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Pas utilisé directement ici, mais ok de le garder si besoin ailleurs
import 'package:flutter/material.dart'; // Changé Cupertino en Material pour CircularProgressIndicator, ou garder les deux si besoin.

import '../modeles/post.dart';
import '../services_firebase/service_firestore.dart';
import '../widgets/widget_vide.dart'; // Assurez-vous que ce widget est amélioré (voir suggestion plus bas)
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: ServiceFirestore().allPosts(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
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
                    style: TextStyle(color: Colors.red[700], fontSize: 16),
                  ),
                ),
              );
            }

            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
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