import 'dart:async' ;
import 'dart:convert' ;

import 'package:flutter/material.dart' ;
import 'package:http/http.dart' as http;
Future<Posts> fetchPosts() async {
  final response =
  await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
// Appropriate action depending upon the
// server response
  if (response.statusCode == 200) {
    return Posts.fromJson(json.decode(response.body));
  } else {
    throw Exception( 'Failed to load posts' );
  }
}
class Posts {
  final int userId;
  final int id;
  final String title;
  Posts({ required this .userId, required this .id, required this .title});
  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      userId: json[ 'userId' ],
      id: json[ 'id' ],
      title: json[ 'title' ],
    );
  }
}
void main() => runApp(const MyApp());
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  late Future<Posts> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetching Data' ,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text( 'Вывод записи ' ),
        ),
        body: Center(
          child: FutureBuilder<Posts>(
            future: futurePosts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text( "${snapshot.error}" );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}