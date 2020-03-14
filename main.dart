import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import "ver_detalles.dart";
import "pokemon.dart";
import 'package:splashscreen/splashscreen.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

//void main() {
//runApp(new MaterialApp(
//home: new MyApp(),
//));
//}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      title: new Text(
        'Welcom',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
      ),

      photoSize: 200.0,
      seconds: 10,
      backgroundColor: Colors.black,
      image: Image.network(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQIYyJiTa_oU_LaPZcTxWJ-n0QCW1sqjmQ1qbIDBjaqyHaoiaH5",
      ),
      navigateAfterSeconds: new AfterSplash(),
    );
  }
}



//*void main() => runApp(MyApp());

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme:
          ThemeData(brightness: Brightness.light, primarySwatch: Colors.cyan),
      darkTheme: ThemeData(
          brightness: Brightness.dark, primarySwatch: Colors.blueGrey),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePage> {
  var url =
      "https://raw.githubusercontent.com/Adrian-Cruz-SanJuan/pokedex_yuko/master/pokemon.json";
  PokeHub pokeHub;

  @override
  void initState() {
    super.initState();
    bajar();
  }

  void bajar() async {
    //async = asincrono
    var res = await http.get(url);
    print(res.body);
    var decodeJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodeJson);
    print(pokeHub.toJson());
    setState(() {});
  }

/*Control de la busqueda*/
  String _searchText = "";
  final TextEditingController _search = new TextEditingController();
  Widget _appBarTitle = new Text("Search Pokemon");
  bool _typing = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: _typing
              ? TextField(
                  autofocus: true,
                  controller: _search,
                  onChanged: (text) {
                    setState(() {});
                  },
                )
              : Text("Search by name"),
          leading: Container(
            child: IconButton(
              icon: Icon(_typing ? Icons.done : Icons.search),
              onPressed: () {
                print("Is typing" + _typing.toString());
                setState(() {
                  _typing = !_typing;
                  _search.text = "";
                });
              },
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent[100],
        ),
        body: pokeHub == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridView.count(
                crossAxisCount: 2,
                children: pokeHub.pokemon
                    .where((poke) => poke.name
                        .toLowerCase()
                        .contains(_search.text.toLowerCase()))
                    .map((poke) => Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => detalles(
                                            pokemon: poke,
                                          )));
                            },
                            child: Hero(
                              tag: poke.img,
                              child: Container(
                                child: Card(
                                  color: Colors.deepPurple[300],
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.0)),
                                  elevation: 3.0,
                                  child: Container(
                                    color: Colors.transparent,
                                    /* checar color*/
                                    child: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        new Container(
                                          height: 100.0,
                                          width: 100.0,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image:
                                                      NetworkImage(poke.img))),
                                        ),
                                        Text(
                                          poke.name,
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList()));
  }
}
