import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widget_member_header.dart'; // Ensure correct path
import '../modeles/post.dart';
import '../modeles/commentaire.dart';
// import '../modeles/formatage_date.dart'; // No longer needed here directly
import '../services_firebase/service_firestore.dart';
import 'widget_vide.dart'; // Ensure correct path

class ListeCommentaire extends StatelessWidget {
  final Post post;

  const ListeCommentaire({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ServiceFirestore().postComment(post.id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // Consider logging the error for debugging
          // print('Error fetching comments: ${snapshot.error}');
          return const Center(child: Text('Error fetching comments.'));
        }

        if (snapshot.hasData && snapshot.data != null) {
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No comments yet.'));
            // return const EmptyBody(); // Keep if EmptyBody is styled appropriately
          }

          // Use ListView.builder directly instead of separated for more control
          // if you don't need separators, or use separated if you still want them.
          return ListView.builder(
            shrinkWrap: true, // Important for nesting in other scrollables
            physics: const NeverScrollableScrollPhysics(), // Prevent nested scrolling issues
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final mapData = data.data() as Map<String, dynamic>?;

              if (mapData == null) {
                // Handle cases where data might not be a map
                // You could return an empty container or an error message widget
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: const Text('Invalid comment data', style: TextStyle(color: Colors.red)),
                );
              }

              final commentaire = Commentaire(
                reference: data.reference,
                id: data.id,
                map: mapData,
              );

              // --- Custom Layout using Container and Column ---
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Padding for the whole comment block
                // Add a bottom border like the Divider does, if desired
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 0.5, // Adjust thickness as needed
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                  children: [
                    // Row 1: Member Header
                    MemberHeader(
                      memberId: commentaire.member,
                      date: commentaire.date,
                    ),
                    // Add spacing between header and text
                    const SizedBox(height: 8.0),
                    // Row 2 (effectively): Comment Text
                    // Wrap text in a Row to allow it to take available width,
                    // or just use Padding if you want padding only on the left.
                    Padding(
                      padding: const EdgeInsets.only(left: 0), // Adjust left padding if needed (e.g., 58.0 to align with header text)
                      child: Text(
                        commentaire.text,
                        style: Theme.of(context).textTheme.bodyMedium, // Adjust style as needed
                      ),
                    ),
                  ],
                ),
              );
              // --- End Custom Layout ---
            },
          );
        } else {
          return const Center(child: Text('No comments available.'));
        }
      },
    );
  }
}