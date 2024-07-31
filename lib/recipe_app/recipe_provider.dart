import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Recipe {
  int? id;
  String title;
  String ingredients;
  String instructions;
  String? image;
  String category;
  bool isFavourite;
  double rating;

  Recipe({
    this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.image,
    required this.category,
    this.isFavourite = false,
    this.rating = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'image': image,
      'category': category,
      'isFavourite': isFavourite ? 1 : 0,
      'rating': rating,
    };
  }

  static Recipe fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      ingredients: map['ingredients'],
      instructions: map['instructions'],
      image: map['image'],
      category: map['category'],
      isFavourite: map['isFavourite'] == 1,
      rating: map['rating'],
    );
  }
}

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  late Database _database;

  List<Recipe> get recipes => _recipes;

  Future<void> initializeDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'recipes.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE recipes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, ingredients TEXT, instructions TEXT, image TEXT, category TEXT, isFavourite INTEGER, rating REAL)',
        );
      },
    );

    await _insertDefaultRecipesIfEmpty();
    await loadRecipes();
  }

  Future<void> _insertDefaultRecipesIfEmpty() async {
    final count = Sqflite.firstIntValue(
      await _database.rawQuery('SELECT COUNT(*) FROM recipes'),
    );

    if (count == 0) {
      List<Recipe> defaultRecipes = [
        Recipe(
            title: 'Pancakes',
            ingredients: 'Flour, Milk, Eggs, Sugar, Baking Powder, Salt',
            instructions: 'Mix ingredients and cook on a hot griddle.',
            category: 'Breakfast',
            image: 'assets/images/pancake.jpg',),
        Recipe(
            title: 'Spaghetti Bolognese',
            ingredients:
                'Spaghetti, Ground Beef, Tomato Sauce, Onions, Garlic, Olive Oil, Salt, Pepper',
            instructions:
                'Cook spaghetti. Brown beef with onions and garlic, add tomato sauce and simmer. Serve over spaghetti.',
            category: 'Lunch',
            image: 'assets/images/spaghetti.jpg',),
        Recipe(
            title: 'Chicken Curry',
            ingredients:
                'Chicken, Curry Powder, Coconut Milk, Onions, Garlic, Ginger, Tomatoes, Salt, Pepper',
            instructions:
                'Cook onions, garlic, and ginger. Add chicken and brown. Add curry powder and tomatoes, then coconut milk. Simmer until cooked.',
            category: 'Dinner',
            image: 'assets/images/chiken curry.jpg',),
        Recipe(
            title: 'Chocolate Cake',
            ingredients:
                'Flour, Sugar, Cocoa Powder, Baking Powder, Eggs, Milk, Butter',
            instructions:
                'Mix dry ingredients. Add wet ingredients and mix well. Bake at 350°F for 30 minutes.',
            category: 'Desserts',
            image: 'assets/images/chocolate cake.jpg',),
      ];

      for (Recipe recipe in defaultRecipes) {
        await _database.insert('recipes', recipe.toMap());
      }
    }
  }

  Future<void> loadRecipes() async {
    final List<Map<String, dynamic>> maps = await _database.query('recipes');
    _recipes = List.generate(maps.length, (i) {
      return Recipe.fromMap(maps[i]);
    });
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    recipe.id = await _database.insert('recipes', recipe.toMap());
    _recipes.add(recipe);
    notifyListeners();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _database.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
    await loadRecipes();
  }

  Future<void> deleteRecipe(int id) async {
    await _database.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
    _recipes.removeWhere((recipe) => recipe.id == id);
    notifyListeners();
  }
}
