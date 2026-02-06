import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Tous',
      'Fruits',
      'Légumes',
      'Viandes',
      'Poissons',
      'Épicerie',
      'Boissons',
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ChoiceChip(
            label: Text(categories[index]),
            selected: index == 0, // Assuming 'Tous' is selected by default
            onSelected: (selected) {},
            selectedColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(
              color: index == 0 ? Colors.white : Colors.black54,
            ),
          );
        },
      ),
    );
  }
}