import 'package:flutter/material.dart';
import 'dart:math';
import 'AlphabetGame.dart';

class NumberGame extends StatefulWidget {
  @override
  _NumberGameState createState() => _NumberGameState();
}

class _NumberGameState extends State<NumberGame> {
  List<ItemModel> itemsdata = [
    ItemModel(
      name: 'one',
      value: 'one',
      imgurl: "assets/images/one.png",
    ),
    ItemModel(
      name: 'two',
      value: 'two',
      imgurl: "assets/images/two.png",
    ),
    ItemModel(
      name: 'three',
      value: 'three',
      imgurl: "assets/images/three.png",
    ),
    ItemModel(
      name: 'four',
      value: 'four',
      imgurl: "assets/images/four.png",
    )
  ];
  List<ItemModel> items;
  List<ItemModel> items2;
  int score;
  bool gameOver;
  @override
  void initState() {
    super.initState();
    initGame();
  }

  initGame() {
    gameOver = false;
    score = 0;
    items = itemsdata.take(5).toList();
    items2 = List<ItemModel>.from(items);
    items.shuffle();
    items2.shuffle();
    itemsdata.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) gameOver = true;
    final data = MediaQuery.of(context);
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.black12,
          child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("Images/images.jpg"),
                    fit: BoxFit.cover,
                  )),
                  child: null,
                ),
                ListTile(
                  title: const Text('Match Numbers'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => NumberGame()));
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: const Text('Match Alphabets'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => AlphabetGame()));
                    // Update the state of the app.
                    // ...
                  },
                ),
              ]),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Number match Game",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 50,
              width: data.size.width / 1,
              color: Colors.lightBlueAccent,
              child: Text(
                "Score: $score",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            if (!gameOver)
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: items
                          .map((item) => Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Draggable<ItemModel>(
                                    data: item,
                                    feedback: Image.asset(
                                      item.imgurl,
                                      height: 100,
                                      width: 100,
                                    ),
                                    childWhenDragging: Image.asset(
                                      item.imgurl,
                                      height: 100,
                                      width: 100,
                                      colorBlendMode: BlendMode.softLight,
                                    ),
                                    child: Image.asset(
                                      item.imgurl,
                                      height: 100,
                                      width: 100,
                                    )),
                              ))
                          .toList(),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: items2
                          .map((item) => Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: DragTarget<ItemModel>(
                                  onAccept: (recivedItem) {
                                    if (item.value == recivedItem.value) {
                                      setState(() {
                                        items.remove(recivedItem);
                                        items2.remove(item);
                                        score += 1;
                                      });
                                    } else {
                                      setState(() {
                                        score += 0;
                                        item.accepting = false;
                                      });
                                    }
                                  },
                                  onLeave: (recivedItem) {
                                    setState(() {
                                      item.accepting = false;
                                    });
                                  },
                                  onWillAccept: (recivedItem) {
                                    setState(() {
                                      item.accepting = true;
                                    });

                                    return true;
                                  },
                                  builder:
                                      (context, acceptedItems, rejectedItems) =>
                                          Container(
                                    alignment: Alignment.center,
                                    height: 100,
                                    width: 100,
                                    color: item.accepting
                                        ? Colors.lightBlueAccent.shade400
                                        : Colors.lightBlueAccent,
                                    child: Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            if (gameOver)
              Center(
                  child: Image.network(
                      "https://image.freepik.com/free-vector/game-pixel-art-retro-game-style_163786-44.jpg")),
            if (gameOver)
              Container(
                width: 300,
                child: RaisedButton(
                  color: Colors.red,
                  child: Text("Restart Game"),
                  onPressed: () {
                    initGame();
                    setState(() {});
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ItemModel {
  final String name;
  final String value;
  final String imgurl;
  bool accepting;
  ItemModel({this.name, this.value, this.imgurl, this.accepting = false});
}
