import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/meal_api_service.dart';
import '../models/meal_detail.dart';
import '../widgets/ingredient_list.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final api = MealApiService();
  MealDetail? _meal;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await api.fetchMealDetail(widget.mealId);
      setState(() {
        _meal = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading recipe')),
      );
    }
  }

  Future<void> _openYoutube(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open Youtube')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final meal = _meal;

    return Scaffold(
      appBar: AppBar(title: const Text('Recipe')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : meal == null
          ? const Center(child: Text('No information'))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal.thumbnail, width: double.infinity, height: 240, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(meal.name, style: Theme.of(context).textTheme.headlineSmall),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Instructions', style: Theme.of(context).textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(meal.instructions),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Ingredients', style: Theme.of(context).textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IngredientList(ingredients: meal.ingredients),
            ),
            if (meal.youtube != null && meal.youtube!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () => _openYoutube(meal.youtube!),
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Watch on Youtube'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
