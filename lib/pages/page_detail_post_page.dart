import 'package:flutter/material.dart';
import '../modeles/post.dart';
import '../services_firebase/service_firestore.dart';
import '../widgets/widget_liste_commentaire.dart';
import '../widgets/widget_post.dart';

class PageDetailPost extends StatefulWidget {
  final Post post;

  const PageDetailPost({super.key, required this.post});

  @override
  State<PageDetailPost> createState() => _PageDetailPostState();
}

class _PageDetailPostState extends State<PageDetailPost> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void _sendComment() {
    if (commentController.text.trim().isEmpty) return;

    ServiceFirestore().addComment(
      post: widget.post,
      text: commentController.text.trim(),
    );

    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commentaires'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Écrivez un commentaire...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendComment,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ListeCommentaire(post: widget.post),
          ],
        ),
      ),
    );
  }
}
