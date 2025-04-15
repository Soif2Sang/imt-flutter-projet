import 'package:flutter/material.dart';
import '../modeles/post.dart';
import '../modeles/formatage_date.dart';

class ContenuPost extends StatelessWidget {
  final Post post;

  const ContenuPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              post.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        if (post.imageUrl.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(post.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            FormatageDate().formatted(post.date),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}
