import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'token.dart' as token;
Future<List<Album>> fetchAlbum() async {
  final response =
      await http.get('https://api.gitter.im/v1/rooms/5881a8bdd73408ce4f44c71a/chatMessages?limit=50',
	  headers: {
		  HttpHeaders.authorizationHeader: 'Bearer ${token.token}',
		  HttpHeaders.contentTypeHeader: 'application/json',
		  HttpHeaders.acceptHeader: 'application/json'
	  	}
	  );
	print(response);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
	var x = (json.decode(response.body));
  List<Album> l = List<Album>();
  for(int i=0;i<x.length;i++){
    l.add(Album.fromJson(json.decode(response.body), i));
  }
  return l;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final String id;
  final String text;
  final String fromUserUsername;
  final String fromUserDisplayName;
  Album({this.id, this.text, this.fromUserDisplayName, this.fromUserUsername});

  factory Album.fromJson(List<dynamic> json, int i) {
    print(i);
    return Album(
      id: json[i]['id'],
      text: json[i]['text'],
      fromUserUsername: json[i]['fromUser']['username'],
      fromUserDisplayName: json[i]['fromUser']['displayName'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('scorelab/scorelab'),
        ),
        body: Center(
          child: FutureBuilder<List<Album>>(
            future: fetchAlbum(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) =>
                    ListTile(
                      title: Text(snapshot.data[index].fromUserUsername),
                      subtitle: Text(snapshot.data[index].text),
                      trailing: Text(snapshot.data[index].fromUserDisplayName),
                    )
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
