import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../modeles/membre.dart';
import '../services_firebase/service_firestore.dart';

class PageEcrirePost extends StatefulWidget {
  final Membre member;
  final void Function(int) newSelection;

  const PageEcrirePost({
    super.key,
    required this.member,
    required this.newSelection,
  });

  @override
  State<PageEcrirePost> createState() => _PageEcrirePostState();
}

class _PageEcrirePostState extends State<PageEcrirePost> {
  final TextEditingController textController = TextEditingController();
  XFile? xFile;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _takePic(ImageSource source) async {
    final XFile? newFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 500,
    );
    setState(() {
      xFile = newFile;
    });
  }

  void _sendPost() {
    FocusScope.of(context).requestFocus(FocusNode());

    if (xFile == null && textController.text.isEmpty) return;

    ServiceFirestore().createPost(
      member: widget.member,
      text: textController.text,
      image: xFile,
    );

    widget.newSelection(0); // Redirige vers la page Accueil
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.border_color),
                      SizedBox(width: 8),
                      Text("Écrire un post"),
                    ],
                  ),
                  const Divider(),
                  TextField(
                    controller: textController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "Votre post",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo),
                        onPressed: () => _takePic(ImageSource.gallery),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => _takePic(ImageSource.camera),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _sendPost,
            child: const Text("Envoyer"),
          ),
        ],
      ),
    );
  }
}
