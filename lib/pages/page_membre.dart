import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../modeles/membre.dart';
import '../services_firebase/service_firestore.dart';
import '../widgets/widget_vide.dart'; // Assuming EmptyBody is in this file
import 'page_profil.dart';

class PageMembres extends StatefulWidget {
  const PageMembres({super.key});

  @override
  State<PageMembres> createState() => _PageMembresState();
}

class _PageMembresState extends State<PageMembres> {
  @override
  Widget build(BuildContext context) {
    // Wrap the content in a Scaffold to add an AppBar
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Liste des Membres'), // Added AppBar title
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ServiceFirestore().allMembers(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;

            if (docs.isEmpty) return const EmptyBody(); // Ensure EmptyBody is defined or imported

            return ListView.separated(
              itemCount: docs.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final data = docs[index];
                final member = Membre(
                  reference: data.reference,
                  id: data.id,
                  map: data.data() as Map<String, dynamic>,
                );

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: member.profilePicture.isNotEmpty ? NetworkImage(member.profilePicture) : null,
                  ),
                  title: Text(member.fullName),
                  subtitle: Text(member.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // This still wraps PageProfil in its own Scaffold, which is correct
                        builder: (_) => Scaffold(
                          appBar: AppBar(
                            title: Text(member.fullName),
                          ),
                          body: PageProfil(member: member),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const EmptyBody(); // Ensure EmptyBody is defined or imported
          }
        },
      ),
    );
  }
}
