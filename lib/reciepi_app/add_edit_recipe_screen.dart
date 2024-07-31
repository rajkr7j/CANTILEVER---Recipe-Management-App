import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/reciepi_app/recipe_provider.dart';

class AddEditRecipeScreen extends StatefulWidget {
  final Recipe? recipe;

  AddEditRecipeScreen({this.recipe});

  @override
  _AddEditRecipeScreenState createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _ingredients = '';
  String _instructions = '';
  String _category = 'Breakfast';
  File? _image;
  double _rating = 0.0;
  bool _isFavourite = false;

  final List<String> _categories = ['Breakfast', 'Lunch', 'Dinner', 'Desserts'];

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _title = widget.recipe!.title;
      _ingredients = widget.recipe!.ingredients;
      _instructions = widget.recipe!.instructions;
      _category = widget.recipe!.category;
      _image =
          widget.recipe!.image != null ? File(widget.recipe!.image!) : null;
      _rating = widget.recipe!.rating;
      _isFavourite = widget.recipe!.isFavourite;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? 'Add Recipe' : 'Edit Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                TextFormField(
                  initialValue: _ingredients,
                  decoration: InputDecoration(labelText: 'Ingredients'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the ingredients';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _ingredients = value!;
                  },
                ),
                TextFormField(
                  initialValue: _instructions,
                  decoration: InputDecoration(labelText: 'Instructions'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the instructions';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _instructions = value!;
                  },
                ),
                DropdownButtonFormField(
                  value: _category,
                  decoration: InputDecoration(labelText: 'Category'),
                  items: _categories.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _category = newValue as String;
                    });
                  },
                ),
                SizedBox(height: 10),
                _image == null
                    ? Text('No image selected.')
                    : Image.file(_image!),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Rating:'),
                    Slider(
                      value: _rating,
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: _rating.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Favourite:'),
                    Switch(
                      value: _isFavourite,
                      onChanged: (value) {
                        setState(() {
                          _isFavourite = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (widget.recipe == null) {
                        recipeProvider.addRecipe(
                          Recipe(
                            title: _title,
                            ingredients: _ingredients,
                            instructions: _instructions,
                            image: _image?.path,
                            category: _category,
                            rating: _rating,
                            isFavourite: _isFavourite,
                          ),
                        );
                      } else {
                        recipeProvider.updateRecipe(
                          Recipe(
                            id: widget.recipe!.id,
                            title: _title,
                            ingredients: _ingredients,
                            instructions: _instructions,
                            image: _image?.path,
                            category: _category,
                            rating: _rating,
                            isFavourite: _isFavourite,
                          ),
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                      widget.recipe == null ? 'Add Recipe' : 'Update Recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
