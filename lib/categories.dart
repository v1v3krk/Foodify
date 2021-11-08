import 'dart:convert'; // adds JSON encoding and decoding

// Recipe object wraps all recipe info in database
class Recipe {

  // Declare Class Properties

  // Unique identifier
  final int id;

  // Name of recipe
  final String name;

  // Description of recipe
  final String description;

  // All ingredients and quanitity of each on recipe
  final Map<dynamic, dynamic> ingredients;

  // All steps to create this recipe and time per step
  final List<dynamic> steps;

  // Base64Encoded String that corresponds to picture of Recipe
  final String image;

  // Common user-chosen tags/properties for the recipe
  final List<dynamic> tags;

  // Names of the columns for the SQFLite database
  static final columns = [
    "id",
    "name",
    "description",
    "ingredients",
    "steps",
    "image",
    "tags"
  ];

  // Constructor for Recipe class
  Recipe(this.id, this.name, this.description, this.ingredients, this.steps,
      this.image, this.tags);

  // When extracting a recipe from the SQFLite database, create a Recipe object and return it
  factory Recipe.fromMap(Map<String, dynamic> data) {
    return Recipe(
      data['id'],
      data['name'],
      data['description'],

      // When retrieving a stringed Map from the database, decode it and cast it to the right type
      (json.decode(data['ingredients']) as Map).cast<dynamic, dynamic>(),

      // When retrieving a stringed List from the database, split it, decode each element and cast it to the right type
      data['steps']
          .split("foodifystepsplit")
          .map((e) => ((json.decode(e) as Map).cast<dynamic, dynamic>()))
          .toList(),

      data['image'],

      // When retrieving a stringed List from the database, split it on " " to match the right type
      data['tags'].split(" "),
    );
  }

  // When storing/updating recipe in the SQFLite Database, return a Map format to store
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,

      // SQFLite accepts Strings (no Maps), therefore it needs to be encoded into string
      "ingredients": json.encode(ingredients).toString(),

      // SQFLite accepts String (no Lists or Maps). 
      // Each entry in list must be encoded into string
      // All encoded strings are joined together into one string
      "steps": steps
          .map((e) => (json.encode(e).toString()))
          .toList()
          .join("foodifystepsplit"),
      
      "image": image,

      // SQFLite accepts Strings (no Lists), therefore it needs to be encoded into string
      "tags": tags.join(" "),
    };
  }
}