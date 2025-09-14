import 'package:flutter/material.dart';

class PersonItem extends StatelessWidget {
  final String? name;
  final String? imageUrl;
  final double imageSize; // optional, default 60

  const PersonItem({
    super.key,
    required this.name,
    required this.imageUrl,
    this.imageSize = 60,
  });

  @override
  Widget build(BuildContext context) {
    // Skip rendering if both name and image are null/empty
    if ((name == null || name!.isEmpty) &&
        (imageUrl == null || imageUrl!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Image.network(
            imageUrl ?? "https://via.placeholder.com/60x60?text=No+Image",
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey,
              width: imageSize,
              height: imageSize,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 4),
        if (name != null && name!.isNotEmpty)
          SizedBox(
            width: imageSize + 10,
            child: Text(
              name!,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
