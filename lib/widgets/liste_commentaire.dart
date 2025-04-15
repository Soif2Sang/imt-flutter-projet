import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeles/post.dart';
import '../modeles/commentaire.dart';
import '../modeles/formatage_date.dart';
import '../services_firebase/service_firestore.dart';
import '../widget_vide.dart';

class ListeCommentaire extends StatelessWidget {
  final Post post;

  const ListeCommentaire({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ServiceFirestore().postComment(post.id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return const EmptyBody();

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final data = docs[index];
              final commentaire = Commentaire(
                reference: data.reference,
                id: data.id,
                map: data.data() as Map<String, dynamic>,
              );

              return ListTile(
                leading: const Icon(Icons.comment),
                title: Text(commentaire.text),
                subtitle: Text(FormatageDate().formatted(commentaire.date)),
              );
            },
          );
        } else {
          return const EmptyBody();
        }
      },
    );
  }
}
