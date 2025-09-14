import 'package:flutter/material.dart';
import 'package:swipemovie/widgets/common/person_item.dart';

class PersonList extends StatelessWidget {
  final String title;
  final List<Map<String, String?>>
  data; // each map should have 'name' and 'image'
  final double imageSize;

  const PersonList({
    super.key,
    required this.title,
    required this.data,
    this.imageSize = 60,
  });

  @override
  Widget build(BuildContext context) {
    // Filter out entries where both name and image are null/empty
    final filteredData = data
        .where(
          (item) =>
              (item['name'] != null && item['name']!.isNotEmpty) ||
              (item['image'] != null && item['image']!.isNotEmpty),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (filteredData.isEmpty)
          Text(
            'No $title available',
            style: const TextStyle(color: Colors.white70),
          )
        else
          SizedBox(
            height: imageSize + 30, // image + name + spacing
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filteredData.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final person = filteredData[index];
                return PersonItem(
                  name: person['name'],
                  imageUrl: person['image'],
                  imageSize: imageSize,
                );
              },
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}
