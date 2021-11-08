import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodify/categories.dart';
import 'package:foodify/database.dart';

import 'package:foodify/recipe.dart';
import 'package:foodify/update.dart';

class RecipeTile extends StatefulWidget {
  final Recipe recipe;
  final Function() updateState;

  const RecipeTile({Key key, this.recipe, this.updateState}) : super(key: key);

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalTime = 0;
    widget.recipe.steps.forEach((element) {
      totalTime += element["time"];
    });

    return Dismissible(
      key: UniqueKey(),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      confirmDismiss: (direction) async {
        // Remove the item from the data source.
        if (direction == DismissDirection.endToStart) {
          await SQLiteDbProvider.db.delete(widget.recipe.id);
          widget.updateState();
          return true;
        }

        if (direction == DismissDirection.startToEnd) {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => UpdatePage(
                    recipe: widget.recipe,
                    updateRecipes: widget.updateState,
                  )));
          return false;
        }
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => RecipePage(
                    recipe: widget.recipe,
                  )));
        },
        child: Container(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  height: 50,
                  width: 50,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.memory(
                      base64Decode(widget.recipe.image),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color.fromRGBO(39, 195, 243, 1)),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 1)),
                  Text(
                    "${totalTime ~/ 60} min. ${totalTime % 60} sec.   -   ${widget.recipe.tags.join(", ")}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(127, 127, 127, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.07),
                  spreadRadius: 7,
                  blurRadius: 10,
                )
              ]),
        ),
      ),
    );
  }
}
