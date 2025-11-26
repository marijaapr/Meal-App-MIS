class MealDetail{
  final String id;
  final String name;
  final String thumbnail;
  final String instructions;
  final List<Map<String, String>>ingredients;//ingredient,measure
  final String? youtube;

  MealDetail({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.instructions,
    required this.ingredients,
    this.youtube,
});

  factory MealDetail.fromJson(Map<String, dynamic> json){
    final List<Map<String, String>> ing=[];
    for(int i=1; i<=20;i++) {
      final ingName = (json['strIngredient$i'] ?? '').toString().trim();
      final measure = (json['strMeasure$i'] ?? '').toString().trim();
      if (ingName.isNotEmpty) {
        ing.add({
          'ingredient': ingName,
          'measure': measure,
        });
      }
    }

      return MealDetail(
          id: json['idMeal'],
          name: json['strMeal'],
          thumbnail: json['strMealThumb'],
          instructions: json['strInstructions'] ?? '',
          ingredients: ing,
          youtube: (json['strYoutube'] as String?)?.trim().isEmpty == true ? null : json['strYoutube'],
      );



  }
}