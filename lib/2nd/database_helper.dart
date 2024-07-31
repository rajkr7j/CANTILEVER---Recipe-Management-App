import 'package:recipe_app/2nd/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        instructions TEXT NOT NULL,
        imagePath TEXT,
        category TEXT NOT NULL,
        rating REAL,
        isFavourite INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertRecipe(Recipe recipe) async {
    final db = await instance.database;
    await db.insert('recipes', recipe.toMap());
  }

  Future<List<Recipe>> fetchRecipes() async {
    final db = await instance.database;
    final maps = await db.query('recipes', orderBy: 'title');
    return List.generate(maps.length, (i) {
      return Recipe.fromMap(maps[i]);
    });
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final db = await instance.database;
    await db.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<void> deleteRecipe(int id) async {
    final db = await instance.database;
    await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final db = await instance.database;
    final maps = await db.query(
      'recipes',
      where: 'title LIKE ? OR ingredients LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Recipe.fromMap(maps[i]);
    });
  }
}
