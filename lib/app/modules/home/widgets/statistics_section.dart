import 'package:flutter/material.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'title': 'Produits', 'value': '1200+'},
      {'title': 'Clients satisfaits', 'value': '5000+'},
      {'title': 'Livraisons', 'value': '10k+'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: stats.map((stat) {
              return Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        stat['value'] as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stat['title'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}