import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodify/categories.dart';
import 'package:foodify/database.dart';

class UpdatePage extends StatefulWidget {
  final Recipe recipe;
  final Function updateRecipes;
  const UpdatePage({Key key, this.recipe, this.updateRecipes})
      : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState(recipe);
}

class _UpdatePageState extends State<UpdatePage> {

  // Check create.dart for all variable meanings
  // This file is a copy of that which initializes all known initial data from passed Recipe
  Map<String, dynamic> recipeInfo;
  TextEditingController nameController;
  TextEditingController descriptionController;
  TextEditingController ingredientNameController;
  TextEditingController ingredientQuantityController;
  TextEditingController stepController;
  TextEditingController stepMinuteController;
  TextEditingController stepSecondController;
  TextEditingController tagController;
  bool ingredientValidator;
  bool stepsValidator;
  bool tagsValidator;
  bool formValidator;

  // Pass Recipe from parent to child while still in initializer
  _UpdatePageState(Recipe r) {
    recipeInfo = {
      "id": r.id,
      "name": r.name,
      "description": r.description,
      "ingredients": r.ingredients,
      "steps": r.steps,
      "image": r.image,
      "tags": r.tags,
    };

    nameController = TextEditingController(text: r.name);
    descriptionController = TextEditingController(text: r.description);
    ingredientNameController = TextEditingController();
    ingredientQuantityController = TextEditingController();
    stepSecondController = TextEditingController();
    stepController = TextEditingController();
    stepMinuteController = TextEditingController();
    tagController = TextEditingController();

    ingredientValidator = false;
    stepsValidator = false;
    tagsValidator = false;
    formValidator = false;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Color(0xffffffff),
      child: NestedScrollView(
          headerSliverBuilder: (BuildContext cont, bool innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  "Update",
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontWeight: FontWeight.bold),
                ),
                backgroundColor: Color.fromRGBO(39, 195, 243, 1),
                leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.chevron_left, color: Colors.white)),
              )
            ];
          },
          body: ListView(
            padding: EdgeInsets.only(bottom: 120, top: 20),
            shrinkWrap: true,
            children: <Widget>[

              // Update Recipe Name
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  padding: EdgeInsets.only(top: 5),
                  child: Text("Recipe Name",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(39, 195, 243, 1),
                        fontWeight: FontWeight.bold,
                      ))),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: CupertinoTextField(
                  controller: nameController,
                  onChanged: (text) {
                    setState(() {
                      recipeInfo["name"] = text;
                    });
                  },
                  placeholder: "Name",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Divider(),

              // Update Recipe Description
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  padding: EdgeInsets.only(top: 5),
                  child: Text("Recipe Description",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(39, 195, 243, 1),
                        fontWeight: FontWeight.bold,
                      ))),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: CupertinoTextField(
                  controller: descriptionController,
                  placeholder: "Description",
                  style: TextStyle(fontSize: 15),
                  minLines: 5,
                  maxLines: 5,
                  onChanged: (text) {
                    setState(() {
                      recipeInfo["description"] = text;
                    });
                  },
                ),
              ),
              Divider(),

              // Update Recipe Ingredients
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  padding: EdgeInsets.only(top: 5),
                  child: Text("Recipe Ingredients",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(39, 195, 243, 1),
                        fontWeight: FontWeight.bold,
                      ))),
              Column(
                children: recipeInfo["ingredients"]
                    .keys
                    .map<Widget>(
                      (e) => Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${recipeInfo["ingredients"][e]} of $e",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  recipeInfo["ingredients"].remove(e);
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                    size: 20,
                                  )),
                            )
                          ],
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
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
              Column(
                children: [
                  Container(
                    child: Column(children: <Widget>[
                      CupertinoTextField(
                        placeholder: "Ingredient Name",
                        style: TextStyle(fontSize: 15),
                        controller: ingredientNameController,
                      ),
                      SizedBox(height: 10),
                      CupertinoTextField(
                        placeholder: "Ingredient Quantity",
                        style: TextStyle(fontSize: 15),
                        controller: ingredientQuantityController,
                      ),
                      ingredientValidator ? SizedBox(height: 10) : SizedBox(),
                      ingredientValidator
                          ? Text(
                              "Please fill in both fields.",
                              style: TextStyle(fontSize: 13, color: Colors.red),
                              textAlign: TextAlign.start,
                            )
                          : SizedBox()
                    ]),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
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
                  GestureDetector(
                    onTap: () {
                      if (ingredientNameController.text != "" &&
                          ingredientQuantityController.text != "") {
                        setState(() {
                          recipeInfo["ingredients"]
                                  [ingredientNameController.text] =
                              ingredientQuantityController.text;
                          ingredientNameController.text = "";
                          ingredientQuantityController.text = "";
                          ingredientValidator = false;
                        });
                      } else {
                        setState(() {
                          ingredientValidator = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      width: 150,
                      child: Text(
                        "Add Ingredient",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(39, 195, 243, 1),
                          borderRadius: BorderRadius.circular(90),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.09),
                              spreadRadius: 7,
                              blurRadius: 10,
                            )
                          ]),
                    ),
                  ),
                ],
              ),
              Divider(),

              // Update Recipe Steps
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  padding: EdgeInsets.only(top: 5),
                  child: Text("Recipe Steps",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(39, 195, 243, 1),
                        fontWeight: FontWeight.bold,
                      ))),
              Column(
                children: recipeInfo["steps"]
                    .asMap()
                    .keys
                    .map<Widget>(
                      (e) => Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${e + 1}. ${recipeInfo["steps"][e]["step"]}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      recipeInfo["steps"].removeAt(e);
                                    });
                                  },
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.grey,
                                        size: 20,
                                      )),
                                )
                              ],
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
                              "${recipeInfo["steps"][e]["time"] ~/ 60} min ${recipeInfo["steps"][e]["time"] % 60} sec",
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
              Column(
                children: [
                  Container(
                    child: Column(children: <Widget>[
                      CupertinoTextField(
                        placeholder: "Step Description",
                        style: TextStyle(fontSize: 15),
                        controller: stepController,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoTextField(
                              controller: stepMinuteController,
                              placeholder: "0",
                              style: TextStyle(fontSize: 15),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            " min.",
                            style: TextStyle(fontSize: 14),
                          )),
                          Expanded(
                            child: CupertinoTextField(
                              controller: stepSecondController,
                              placeholder: "0",
                              style: TextStyle(fontSize: 15),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            " sec.",
                            style: TextStyle(fontSize: 14),
                          )),
                        ],
                      ),
                      stepsValidator ? SizedBox(height: 10) : SizedBox(),
                      stepsValidator
                          ? Text(
                              "Please fill in all fields properly.",
                              style: TextStyle(fontSize: 13, color: Colors.red),
                              textAlign: TextAlign.start,
                            )
                          : SizedBox()
                    ]),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
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
                  GestureDetector(
                    onTap: () {
                      if (stepController.text != "" &&
                          stepSecondController.text != "" &&
                          stepMinuteController.text != "" &&
                          isNumeric(stepSecondController.text) &&
                          isNumeric(stepMinuteController.text)) {
                        setState(() {
                          recipeInfo["steps"].add({
                            "step": stepController.text,
                            "time": int.parse(stepMinuteController.text) * 60 +
                                int.parse(stepSecondController.text),
                          });
                          stepController.text = "";
                          stepMinuteController.text = "";
                          stepSecondController.text = "";
                          stepsValidator = false;
                        });
                      } else {
                        setState(() {
                          stepsValidator = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      width: 150,
                      child: Text(
                        "Add Step",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(39, 195, 243, 1),
                          borderRadius: BorderRadius.circular(90),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.09),
                              spreadRadius: 7,
                              blurRadius: 10,
                            )
                          ]),
                    ),
                  ),
                ],
              ),
              Divider(),

              // Update Recipe Tags
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  padding: EdgeInsets.only(top: 5),
                  child: Text("Recipe Tags",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(39, 195, 243, 1),
                        fontWeight: FontWeight.bold,
                      ))),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                padding: EdgeInsets.only(top: 5),
                child: Row(
                    children: recipeInfo["tags"]
                        .asMap()
                        .keys
                        .map<Widget>((e) => Container(
                              padding: EdgeInsets.all(7),
                              margin: EdgeInsets.only(right: 5),
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
                              child: Row(
                                children: [
                                  Text(
                                    recipeInfo["tags"][e],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        recipeInfo["tags"].removeAt(e);
                                      });
                                    },
                                    child: Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Icon(
                                          Icons.cancel,
                                          color: Colors.grey,
                                          size: 20,
                                        )),
                                  )
                                ],
                              ),
                            ))
                        .toList()),
              ),
              Column(
                children: [
                  Container(
                    child: Column(children: <Widget>[
                      CupertinoTextField(
                        placeholder: "Tag",
                        style: TextStyle(fontSize: 15),
                        controller: tagController,
                      ),
                      tagsValidator ? SizedBox(height: 10) : SizedBox(),
                      tagsValidator
                          ? Text(
                              "Please fill in all fields properly.",
                              style: TextStyle(fontSize: 13, color: Colors.red),
                              textAlign: TextAlign.start,
                            )
                          : SizedBox()
                    ]),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
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
                  GestureDetector(
                    onTap: () {
                      if (tagController.text != "") {
                        setState(() {
                          recipeInfo["tags"]
                              .add(tagController.text.replaceAll(" ", ""));
                          tagController.text = "";
                          tagsValidator = false;
                        });
                      } else {
                        setState(() {
                          tagsValidator = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      width: 150,
                      child: Text(
                        "Add Tag",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(39, 195, 243, 1),
                          borderRadius: BorderRadius.circular(90),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.09),
                              spreadRadius: 7,
                              blurRadius: 10,
                            )
                          ]),
                    ),
                  ),
                ],
              ),
              Divider(),

              // Submit Button to Update Recipe
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  padding: EdgeInsets.only(top: 5),
                  child: CupertinoButton(
                    color: Color.fromRGBO(39, 195, 243, 1),
                    child: Text(
                      "Update Recipe",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (recipeInfo["name"] != "" &&
                          recipeInfo["description"] != "" &&
                          recipeInfo["ingredients"] != {} &&
                          recipeInfo["steps"] != [] &&
                          recipeInfo["image"] != null &&
                          recipeInfo["tags"] != []) {
                        Recipe updatedRecipe = Recipe(
                            recipeInfo["id"],
                            recipeInfo["name"],
                            recipeInfo["description"],
                            recipeInfo["ingredients"],
                            recipeInfo["steps"],
                            recipeInfo["image"],
                            recipeInfo["tags"]);

                        await SQLiteDbProvider.db.update(updatedRecipe);
                        widget.updateRecipes();
                        Navigator.of(context).pop();
                      } else {
                        setState(() {
                          formValidator = true;
                        });
                      }
                    },
                  )),
              formValidator ? SizedBox(height: 10) : SizedBox(),
              formValidator
                  ? Text(
                      "Please fill in all fields properly.",
                      style: TextStyle(fontSize: 13, color: Colors.red),
                      textAlign: TextAlign.center,
                    )
                  : SizedBox()
            ],
          )),
    );
  }
}
