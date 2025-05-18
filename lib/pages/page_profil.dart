import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeles/constantes.dart';
import '../services_firebase/service_authentification.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/membre.dart';
import '../modeles/post.dart';
import '../widgets/widget_post.dart';
import '../widgets/widget_avatar.dart';
import '../widgets/widget_bouton_camera.dart';
import 'page_modifier_profil.dart';

class PageProfil extends StatefulWidget {
  final Membre member;
  const PageProfil({super.key, required this.member});

  @override
  State<PageProfil> createState() => _PageProfilState();
}

class _PageProfilState extends State<PageProfil> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ServiceFirestore().postForMember(widget.member.id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          final int length = docs.length;
          final bool isMe = ServiceAuthentification().isMe(widget.member.id);
          final int indexToAdd = 1;

          return ListView.builder(
            itemCount: length + indexToAdd,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    // Couverture avec bouton de changement
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            image: widget.member.coverPicture.isNotEmpty
                                ? DecorationImage(
                              image: NetworkImage(widget.member.coverPicture),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                        ),
                        if (isMe)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BoutonCamera(
                              type: coverPictureKey,
                              id: widget.member.id,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Avatar avec bouton de modification
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Avatar(
                          radius: 60,
                          url: widget.member.profilePicture,
                        ),
                        if (isMe)
                          BoutonCamera(
                            type: profilePictureKey,
                            id: widget.member.id,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.member.fullName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.member.description,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (isMe)
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ModifierProfil(member: widget.member),
                            ),
                          );
                        },
                        child: const Text("Modifier le profil"),
                      ),
                  ],
                );
              } else if (index < length + indexToAdd) {
                // Affichage des posts
                print(index - indexToAdd);
                final postDoc = docs[index - indexToAdd];
                final post = Post(
                  reference: postDoc.reference,
                  id: postDoc.id,
                  map: postDoc.data() as Map<String, dynamic>,
                );
                return WidgetPost(post: post);
              } else {
                // This case handles the case where index is out of bounds.
                return const SizedBox(); // This prevents invalid index access.
              }
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

}
