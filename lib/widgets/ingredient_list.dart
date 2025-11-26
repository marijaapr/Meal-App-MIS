// lib/widgets/ingredient_list.dart
import 'package:flutter/material.dart';



class IngredientList extends StatelessWidget {
  final List<Map<String, String>> ingredients;

  const IngredientList({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients.map((item) {
        final ing = item["ingredient"] ?? "";
        final measure = item["measure"] ?? "";

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Icon(Icons.circle, size: 6),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "$ing - $measure",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
