import 'package:flutter/material.dart';
import '../modeles/post.dart';
import '../pages/page_detail_post_page.dart';
import '../services_firebase/service_authentification.dart';
import '../services_firebase/service_firestore.dart';
import 'widget_contenu_post.dart';
class WidgetPost extends StatelessWidget {
  final Post post;
  const WidgetPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // Get the current user ID once for efficiency and null safety
    final String? myId = ServiceAuthentification().myId;
    // Determine if the current user liked the post
    final bool isLiked = myId != null && post.likes.contains(myId);

    return Card(
      elevation: 1,
      // Using ClipRRect to ensure InkWell ripple effect is contained within the card's rounded corners if any
      clipBehavior: Clip.antiAlias, // Helps InkWell ripple conform to Card shape
      child: Column( // Changed outer Container to Column for direct children management
        children: [
          // Padding added around the content if needed, or keep it in ContenuPost
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0), // Adjust padding as needed
            child: ContenuPost(post: post),
          ),
          const Divider(height: 1), // Divider height 1 is often visually better
          // Row for actions like Like and Comment
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0), // Add vertical padding for the actions row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // --- Like Action ---
                InkWell(
                  // Add splash color for visual feedback, optional
                  // splashColor: Theme.of(context).primaryColorLight.withOpacity(0.2),
                  // Add highlight color, optional
                  // highlightColor: Theme.of(context).primaryColorLight.withOpacity(0.1),
                  onTap: () {
                    // Use the pre-fetched myId
                    if (myId != null) {
                      ServiceFirestore().addLike(memberID: myId, post: post);
                    } else {
                      // Optional: Handle case where user is not logged in
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please log in to like posts.")),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Padding for tap area
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Row takes minimum space
                      children: [
                        Icon(
                          // Using Icons.star_border for the non-liked state might be clearer
                          isLiked ? Icons.star : Icons.star_border,
                          color: isLiked
                              ? Theme.of(context).colorScheme.primary
                          // Use a less prominent color for the non-liked state
                              : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          size: 20.0, // Slightly smaller icon might fit better
                        ),
                        const SizedBox(width: 4), // Space between icon and text
                        Text(
                          // Dynamic text: Show count or just "Like"
                          '${post.likes.length} ${post.likes.length == 1 ? "Like" : "Likes"}',
                          style: TextStyle(
                            // Match text color with icon state potentially
                            color: isLiked
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.9),
                            fontWeight: isLiked ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- Comment Action ---
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PageDetailPost(post: post),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Padding for tap area
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Row takes minimum space
                      children: [
                        Icon(
                          Icons.message_outlined, // Using outlined version
                          size: 20.0, // Match size with like icon
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7), // Consistent color
                        ),
                        const SizedBox(width: 4), // Space between icon and text
                        Text(
                          'Comment', // Or show comment count: '${post.commentCount ?? 0} Comments'
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}