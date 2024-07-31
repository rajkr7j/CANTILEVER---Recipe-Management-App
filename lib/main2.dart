// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:recipe_app/2nd/recipe.dart';
// import 'package:recipe_app/2nd/recipe_provider.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => RecipeProvider(),
//       child: MaterialApp(
//         title: 'Recipe App',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: const RecipeListScreen(),
//       ),
//     );
//   }
// }

// class RecipeListScreen extends StatefulWidget {
//   const RecipeListScreen({Key? key}) : super(key: key);

//   @override
//   State<RecipeListScreen> createState() => _RecipeListScreenState();
// }

// class _RecipeListScreenState extends State<RecipeListScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<RecipeProvider>(context, listen: false).fetchRecipes();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final recipeProvider = Provider.of<RecipeProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Recipe App'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () =>
//                 showSearch(context: context, delegate: RecipeSearchDelegate()),
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: recipeProvider.recipes.length,
//         itemBuilder: (context, index) {
//           final recipe = recipeProvider.recipes[index];
//           return ListTile(
//             title: Text(recipe.title),
//             subtitle: Text(recipe.category),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(recipe.isFavourite
//                       ? Icons.favorite
//                       : Icons.favorite_border),
//                   onPressed: () {
//                     recipe.isFavourite = !recipe.isFavourite;
//                     recipeProvider.updateRecipe(recipe);
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.edit),
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => RecipeFormScreen(recipe: recipe),
//                       ),
//                     );
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: () {
//                     recipeProvider.deleteRecipe(recipe.id!);
//                   },
//                 ),
//               ],
//             ),
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => RecipeDetailScreen(recipe: recipe),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => const RecipeFormScreen(),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class RecipeDetailScreen extends StatelessWidget {
//   final Recipe recipe;
//   const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(recipe.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (recipe.imagePath != null) Image.file(File(recipe.imagePath!)),
//             const SizedBox(height: 16),
//             Text('Ingredients:', style: Theme.of(context).textTheme.headline6),
//             Text(recipe.ingredients),
//             const SizedBox(height: 16),
//             Text('Instructions:', style: Theme.of(context).textTheme.headline6),
//             Text(recipe.instructions),
//             const SizedBox(height: 16),
//             Text('Category: ${recipe.category}',
//                 style: Theme.of(context).textTheme.subtitle1),
//             const SizedBox(height: 16),
//             Text('Rating: ${recipe.rating}',
//                 style: Theme.of(context).textTheme.subtitle1),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RecipeFormScreen extends StatefulWidget {
//   final Recipe? recipe;

//   const RecipeFormScreen({Key? key, this.recipe}) : super(key: key);

//   @override
//   State<RecipeFormScreen> createState() => _RecipeFormScreenState();
// }

// class _RecipeFormScreenState extends State<RecipeFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _ingredientsController = TextEditingController();
//   final _instructionsController = TextEditingController();
//   final _categoryController = TextEditingController();
//   String? _imagePath;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.recipe != null) {
//       _titleController.text = widget.recipe!.title;
//       _ingredientsController.text = widget.recipe!.ingredients;
//       _instructionsController.text = widget.recipe!.instructions;
//       _categoryController.text = widget.recipe!.category;
//       _imagePath = widget.recipe!.imagePath;
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imagePath = pickedFile.path;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.recipe == null ? 'Add Recipe' : 'Edit Recipe'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   controller: _titleController,
//                   decoration: const InputDecoration(labelText: 'Title'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a title';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _ingredientsController,
//                   decoration: const InputDecoration(labelText: 'Ingredients'),
//                   maxLines: 3,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter ingredients';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _instructionsController,
//                   decoration: const InputDecoration(labelText: 'Instructions'),
//                   maxLines: 5,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter instructions';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _categoryController,
//                   decoration: const InputDecoration(labelText: 'Category'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a category';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 _imagePath != null
//                     ? Image.file(File(_imagePath!))
//                     : const Placeholder(fallbackHeight: 200),
//                 TextButton(
//                   onPressed: _pickImage,
//                   child: const Text('Pick Image'),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       final newRecipe = Recipe(
//                         id: widget.recipe?.id,
//                         title: _titleController.text,
//                         ingredients: _ingredientsController.text,
//                         instructions: _instructionsController.text,
//                         imagePath: _imagePath,
//                         category: _categoryController.text,
//                       );

//                       if (widget.recipe == null) {
//                         Provider.of<RecipeProvider>(context, listen: false)
//                             .addRecipe(newRecipe);
//                       } else {
//                         Provider.of<RecipeProvider>(context, listen: false)
//                             .updateRecipe(newRecipe);
//                       }

//                       Navigator.of(context).pop();
//                     }
//                   },
//                   child: Text(
//                       widget.recipe == null ? 'Add Recipe' : 'Update Recipe'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class RecipeSearchDelegate extends SearchDelegate {
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final recipeProvider = Provider.of<RecipeProvider>(context);
//     final results = recipeProvider.recipes.where((recipe) {
//       return recipe.title.toLowerCase().contains(query.toLowerCase()) ||
//           recipe.ingredients.toLowerCase().contains(query.toLowerCase());
//     }).toList();

//     return ListView.builder(
//       itemCount: results.length,
//       itemBuilder: (context, index) {
//         final recipe = results[index];
//         return ListTile(
//           title: Text(recipe.title),
//           subtitle: Text(recipe.category),
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => RecipeDetailScreen(recipe: recipe),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final recipeProvider = Provider.of<RecipeProvider>(context);
//     final suggestions = recipeProvider.recipes.where((recipe) {
//       return recipe.title.toLowerCase().contains(query.toLowerCase()) ||
//           recipe.ingredients.toLowerCase().contains(query.toLowerCase());
//     }).toList();

//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         final recipe = suggestions[index];
//         return ListTile(
//           title: Text(recipe.title),
//           subtitle: Text(recipe.category),
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => RecipeDetailScreen(recipe: recipe),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
