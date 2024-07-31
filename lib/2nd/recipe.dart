class Recipe {
  int? id;
  String title;
  String ingredients;
  String instructions;
  String? imagePath;
  String category;
  double rating;
  bool isFavourite;

  Recipe({
    this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.imagePath,
    required this.category,
    this.rating = 0.0,
    this.isFavourite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'imagePath': imagePath,
      'category': category,
      'rating': rating,
      'isFavourite': isFavourite ? 1 : 0,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      ingredients: map['ingredients'],
      instructions: map['instructions'],
      imagePath: map['imagePath'],
      category: map['category'],
      rating: map['rating'],
      isFavourite: map['isFavourite'] == 1,
    );
  }
}
