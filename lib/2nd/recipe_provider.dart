import 'package:flutter/material.dart';
import 'package:recipe_app/2nd/database_helper.dart';
import 'package:recipe_app/2nd/recipe.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  Future<void> fetchRecipes() async {
    _recipes = await DatabaseHelper.instance.fetchRecipes();
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await DatabaseHelper.instance.insertRecipe(recipe);
    await fetchRecipes();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await DatabaseHelper.instance.updateRecipe(recipe);
    await fetchRecipes();
  }

  Future<void> deleteRecipe(int id) async {
    await DatabaseHelper.instance.deleteRecipe(id);
    await fetchRecipes();
  }

  Future<void> searchRecipes(String query) async {
    _recipes = await DatabaseHelper.instance.searchRecipes(query);
    notifyListeners();
  }
}
