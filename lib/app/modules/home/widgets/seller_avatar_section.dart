import 'package:flutter/material.dart';

class SellerAvatarSection extends StatelessWidget {
  const SellerAvatarSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sellers = [
      {'name': 'Marchand 1', 'rating': '4.8'},
      {'name': 'Marchand 2', 'rating': '4.9'},
      {'name': 'Marchand 3', 'rating': '4.7'},
      {'name': 'Marchand 4', 'rating': '4.6'},
      {'name': 'Marchand 5', 'rating': '4.9'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meilleurs vendeurs',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: sellers.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final seller = sellers[index];
              return Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.storefront,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    seller['name'] as String,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        seller['rating'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}