import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/recipe_app/home_screen.dart';
import 'package:recipe_app/recipe_app/recipe_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipeProvider(),
      child: MaterialApp(
        title: 'Recipe App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
