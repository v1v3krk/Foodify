import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodify/recipes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',

      // App will be on the Recipes Page
      home: RecipesPage(),

      debugShowCheckedModeBanner: false,
    );
  }
}
