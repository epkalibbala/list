import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:list_challenge/list.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Identity> names = [];
  bool _isLoading = false;

  Future<Null> fetchUni() {
    setState(() {
      _isLoading = true;
    }); 
    names = [];
    return http
        .get('https://jsonplaceholder.typicode.com/todos')
        .then<Null>((http.Response response) {
      final List fetchedList = json.decode(response.body);
      print(response.body);
      if (fetchedList == null) {
        setState(() {
      _isLoading = false;
    });
        return;
      }
      fetchedList.forEach((dynamic uniData) {
        final Identity uni = Identity(
            userId: uniData['userId'],
            id: uniData['id'],
            title: uniData['title'],
            completed: uniData['completed']);
        names.add(uni);
      });
      setState(() {
      _isLoading = false;
    });
    }).catchError((error) {
      setState(() {
      _isLoading = false;
    });
      return;
    });
  }

  @override
  void initState() {
    fetchUni();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("My List App"),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : new Container(
        child: new ListView.builder(
          reverse: false,
          itemBuilder: (context, int index) => EachList(index, this.names),
          itemCount: this.names.length,
        ),
      ),
    );
  }
}

class EachList extends StatelessWidget {
  final int index;
  final List<Identity> name;
  EachList(this.index, this.name);
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Container(
        padding: EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(right: 10.0)),
            new Text(
              '${name[index].userId.toString()}\n${name[index].id.toString()}\n${name[index].title}\n${name[index].completed.toString()}',
              style: TextStyle(fontSize: 20.0),
            )
          ],
        ),
      ),
    );
  }
}
