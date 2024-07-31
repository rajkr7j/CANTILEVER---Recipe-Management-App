import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/reciepi_app/add_edit_recipe_screen.dart';
import 'package:recipe_app/reciepi_app/recipe_detail_screen.dart';
import 'dart:io';

import 'package:recipe_app/reciepi_app/recipe_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _initializeDatabaseFuture;

  @override
  void initState() {
    super.initState();
    _initializeDatabaseFuture =
        Provider.of<RecipeProvider>(context, listen: false)
            .initializeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe App'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditRecipeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _initializeDatabaseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error initializing database'));
          } else {
            return Consumer<RecipeProvider>(
              builder: (context, recipeProvider, child) {
                if (recipeProvider.recipes.isEmpty) {
                  return Center(child: Text('No recipes available.'));
                }
                return ListView.builder(
                  itemCount: recipeProvider.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipeProvider.recipes[index];
                    return ListTile(
                      leading: recipe.image != null
                          ? (recipe.image!.startsWith('assets/')
                              ? Image.asset(
                                  recipe.image!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(recipe.image!),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ))
                          : null,
                      title: Text(recipe.title),
                      subtitle: Text(recipe.category),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
