import 'dart:async'; // allows for asynchronous execution
import 'dart:io'; // allows for file reading/writing from directory
import 'dart:convert'; // adds JSON encoding and decoding
import 'package:path/path.dart'; // allows for file retreival from directory
import 'package:path_provider/path_provider.dart'; // allows for file retreival from directory

import 'package:sqflite/sqflite.dart'; // USED TO CREATE/MANAGE DATABASE

import 'categories.dart';

// Stores all methods to create/manage/edit database
class SQLiteDbProvider {

  // Abstract contructors
  SQLiteDbProvider._();
  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database _database;

  // If database doesn't exist, create it
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  // Initialize database
  initDB() async {

    // Store application folder structure
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Store database directory path
    String path = join(documentsDirectory.path, "RecipeDB.db");

    // Create the database via SQL
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Recipe ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "description TEXT,"
          "ingredients TEXT,"
          "steps TEXT,"
          "image TEXT,"
          "tags TEXT"
          ")");
    });
  }

  // Return Future list of all recipes in the database
  Future<List<Recipe>> getAllRecipes() async {
    final db = await database;

    // Retrieve all data entries
    List<Map> results =
        await db.query("Recipe", columns: Recipe.columns, orderBy: "id ASC");

    // Transform the maps from the database to be wrapped in the Recipe class
    List<Recipe> recipes = new List();
    results.forEach((result) {
      Recipe recipe = Recipe.fromMap(result);
      recipes.add(recipe);
    });

    return recipes;
  }

  // Retrieve a recipe with a given unique id
  Future<Recipe> getRecipeById(int id) async {
    final db = await database;
    var result = await db.query("Recipe", where: "id = ", whereArgs: [id]);
    return result.isNotEmpty ? Recipe.fromMap(result.first) : Null;
  }

  // insert new recipe into database
  insert(Recipe recipe) async {
    final db = await database;

    // Whatever the max id is, get that +1 for a new unique id
    var maxIdResult =
        await db.rawQuery("SELECT MAX(id)+1 as last_inserted_id FROM Recipe");

    // Store new unique id
    var id = maxIdResult.first["last_inserted_id"];

    // Inserting the new recipe
    var result = await db.rawInsert(
        "INSERT Into Recipe ('id', 'name', 'description', 'ingredients', 'steps', 'image', 'tags')"
        " VALUES (?, ?, ?, ?, ?, ?, ?)",
        [
          id,
          recipe.name,
          recipe.description,
          json.encode(recipe.ingredients).toString(),
          recipe.steps
              .map((e) => (json.encode(e).toString()))
              .toList()
              .join("foodifystepsplit"),
          recipe.image,
          recipe.tags.join(" ")
        ]);
    return result;
  }

  // Given a recipe, find its unique id and update it to the rest of the Recipe object
  update(Recipe recipe) async {
    final db = await database;
    var result = await db.update("Recipe", recipe.toMap(),
        where: "id = ?", whereArgs: [recipe.id]);
    return result;
  }

  // Delete a recipe from the database given the unique id
  delete(int id) async {
    final db = await database;
    db.delete("Recipe", where: "id = ?", whereArgs: [id]);
  }
}