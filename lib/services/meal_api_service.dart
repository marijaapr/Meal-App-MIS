import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal_detail.dart';

class MealApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Categories
  Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$baseUrl/categories.php');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List categories = data['categories'] ?? [];
      return categories.map((c) => Category.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Meals by category
  Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final url = Uri.parse('$baseUrl/filter.php?c=$category');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List meals = data['meals'] ?? [];
      return meals.map((m) => MealSummary.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load meals for $category');
    }
  }

  // Lookup detail by id
  Future<MealDetail> fetchMealDetail(String id) async {
    final url = Uri.parse('$baseUrl/lookup.php?i=$id');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List meals = data['meals'] ?? [];
      if (meals.isEmpty) throw Exception('Meal not found');
      return MealDetail.fromJson(meals.first);
    } else {
      throw Exception('Failed to load meal detail');
    }
  }

  // Random
  Future<MealDetail> fetchRandomMeal() async {
    final url = Uri.parse('$baseUrl/random.php');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List meals = data['meals'] ?? [];
      return MealDetail.fromJson(meals.first);
    } else {
      throw Exception('Failed to load random meal');
    }
  }
}
