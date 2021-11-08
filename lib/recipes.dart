// Flutter classes
import 'package:flutter/cupertino.dart'; // iOS
import 'package:flutter/material.dart'; // Android

import 'create.dart';
import 'database.dart';
import 'recipe_tile.dart';
import 'categories.dart';

// Flutter Stateful Widget for Recipe Page
class RecipesPage extends StatefulWidget {
  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {

  // Load all recipes in the database and store it on initialization of the page
  Future<List<Recipe>> recipe = SQLiteDbProvider.db.getAllRecipes();

  // Callback function for other classes to reload the page with changed entries
  updateState() {
    setState(() {
      recipe = SQLiteDbProvider.db.getAllRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {

    // iOS Themed Scaffold
    return CupertinoPageScaffold(
      backgroundColor: Color(0xffffffff),
      child: NestedScrollView(

          // Bar at the top of the page for identification of the page
          headerSliverBuilder: (BuildContext cont, bool innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  "My Recipes",
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontWeight: FontWeight.bold),
                ),
                backgroundColor: Color.fromRGBO(39, 195, 243, 1),

                // Plus icon in top right to create new recipe
                trailing: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => CreatePage(
                                    updateRecipes: updateState,
                                  )));
                    },
                    child: Icon(Icons.add, color: Colors.white)),
              )
            ];
          },

          // Once all recipes load, display page
          body: FutureBuilder<List<Recipe>>(
            future: recipe,
            builder:
                (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                return Container(

                  // If there are any previous recipes, load them and show
                  // else show nothing but button in center to add recipe
                  child: snapshot.data.length != 0
                      ? ListView(
                          padding: EdgeInsets.only(bottom: 120, top: 15),
                          shrinkWrap: true,

                          // For each recipe return the tile
                          children: <Widget>[
                            Text("Swipe left to edit and right to delete.", textAlign: TextAlign.center,),
                            SizedBox(height:20),
                            Column(
                              children: snapshot.data
                              .map((e) => RecipeTile(
                                    recipe: e,
                                    updateState: updateState,
                                  ))
                              .toList(),
                            )
                          ]
                          
                        )
                      : Center(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => CreatePage(
                                                updateRecipes: updateState,
                                              )));
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  color: Color.fromRGBO(39, 195, 243, 1),
                                  size: 60,
                                )),
                            SizedBox(height: 10),
                            Text("Create a Recipe"),
                          ],
                        )),
                );
              } else if (snapshot.hasError) {
                children = <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];
              } else {
                children = <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
              }
              return Container(
                child: ListView(
                  padding: EdgeInsets.only(bottom: 120, top: 15),
                  shrinkWrap: true,
                  children: children,
                ),
              );
            },
          )),
    );
  }
}
