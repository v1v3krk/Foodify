import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodify/categories.dart';
import 'dart:convert';

class RecipePage extends StatefulWidget {
  final Recipe recipe;
  const RecipePage({Key key, this.recipe}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Color(0xffffffff),
      child: NestedScrollView(
          headerSliverBuilder: (BuildContext cont, bool innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  widget.recipe.name,
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontWeight: FontWeight.bold),
                ),
                backgroundColor: Color.fromRGBO(39, 195, 243, 1),
                leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    )),
              )
            ];
          },
          body: ListView(
            padding: EdgeInsets.only(bottom: 60),
            children: <Widget>[
              Container(
                height: 150,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.memory(
                    base64Decode(widget.recipe.image),
                  ),
                ),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Description",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromRGBO(39, 195, 243, 1),
                          fontWeight: FontWeight.bold,
                        ))),
                Container(
                  child: Text(
                    widget.recipe.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.09),
                          spreadRadius: 7,
                          blurRadius: 10,
                        )
                      ]),
                ),
                Divider(),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Ingredients",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromRGBO(39, 195, 243, 1),
                          fontWeight: FontWeight.bold,
                        ))),
                Column(
                  children: widget.recipe.ingredients.keys
                      .map(
                        (e) => Container(
                          child: Text(
                            "${widget.recipe.ingredients[e]} of $e",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.09),
                                  spreadRadius: 7,
                                  blurRadius: 10,
                                )
                              ]),
                        ),
                      )
                      .toList(),
                ),
                Divider(),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Steps",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromRGBO(39, 195, 243, 1),
                          fontWeight: FontWeight.bold,
                        ))),
                SizedBox(height: 10),
                Column(
                  children: widget.recipe.steps
                      .asMap()
                      .keys
                      .map(
                        (e) => Column(
                          children: [
                            Container(
                              child: Text(
                                "${e + 1}. ${widget.recipe.steps[e]["step"]}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0),
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.09),
                                      spreadRadius: 7,
                                      blurRadius: 10,
                                    )
                                  ]),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              color: Color(0xffdddddd),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              width: 120,
                              child: Text(
                                "${widget.recipe.steps[e]["time"] ~/ 60} min ${widget.recipe.steps[e]["time"] % 60} sec",
                                style: TextStyle(fontSize: 14),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.09),
                                      spreadRadius: 7,
                                      blurRadius: 10,
                                    )
                                  ]),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              color: Color(0xffdddddd),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
                Container(
                  child: Text(
                    "Enjoy your ${widget.recipe.name}!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(39, 195, 243, 1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.09),
                          spreadRadius: 7,
                          blurRadius: 10,
                        )
                      ]),
                ),
                Divider(),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Tags",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromRGBO(39, 195, 243, 1),
                          fontWeight: FontWeight.bold,
                        ))),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                      children: widget.recipe.tags
                          .map((e) => Container(
                            padding: EdgeInsets.all(7),
                            margin: EdgeInsets.only(right:5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.09),
                                        spreadRadius: 7,
                                        blurRadius: 10,
                                      )
                                    ]),
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ))
                          .toList()),
                )
              ])
            ],
          )),
    );
  }
}
