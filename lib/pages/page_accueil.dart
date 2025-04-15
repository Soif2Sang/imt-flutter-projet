import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modeles/post.dart';
import '../services_firebase/service_firestore.dart';
import '../widget_vide.dart';
import '../widgets/post_widget.dart';

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
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: Text(widget.title),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: ServiceFirestore().allPosts(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            print(snapshot);
            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;

              if (docs.isEmpty) return const EmptyBody();

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  print('ici');
                  print(doc);
                  print(doc.data());
                  final post = Post(
                    reference: doc.reference,
                    id: doc.id,
                    map: doc.data() as Map<String, dynamic>,
                  );
                  print(doc);
                  return WidgetPost(post: post);
                },
              );
            } else {
              return const EmptyBody();
            }
          },
        )
    );
  }
}