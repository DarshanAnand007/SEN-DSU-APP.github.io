import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sen_app/questionspage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> sendGetRequest() async {
    // Define the endpoint  // Replace with your specific endpoint
    final Uri url = Uri.parse(
        'https://api.unsplash.com/photos/random/?client_id=keYInDDK6q6ETrQE0vS2aFvzyA5H-VayHyuJ0xZtMe8');

    // Set up headers
    // final Map<String, String> headers = {
    //   'Authorization': 'Client-ID $accessKey',
    // };

    try {
      // Send the GET request
      final response = await http.get(url);

      // Check for a successful response
      if (response.statusCode == 200) {
        // Parse and print the response body
        setState(() {
          urll = jsonDecode(response.body)['urls']['regular'];
        });
        final data = jsonDecode(response.body);
        debugPrint('Response data: $data');
      } else {
        // Handle non-successful response
        debugPrint('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur
      debugPrint('Error occurred: $e');
    }
  }

  Future<void> sendGet() async {
    List<Widget> temptopics = [];

    // Define the endpoint  // Replace with your specific endpoint
    final Uri url = Uri.parse('http://127.0.0.1:5000/get_document');

    // Set up headers
    // final Map<String, String> headers = {
    //   'Authorization': 'Client-ID $accessKey',
    // };

    try {
      // Send the GET request
      final response = await http.get(url).timeout(const Duration(seconds: 24));

      // Check for a successful response
      if (response.statusCode == 200) {
        debugPrint('1');
        final data = jsonDecode(response.body);
        debugPrint(response.body);
        for (var name in data['names']) {
          debugPrint('10');
          temptopics.add(buildTopics(name, data[name]));
        }
        debugPrint('3');
      } else {
        // Handle non-successful response
        debugPrint('Request failed with status: ${response.statusCode}');
      }
      setState(() {
        topics.addAll(temptopics);
      });
    } catch (e) {
      // Handle any errors that occur
      debugPrint('Error occurred: $e');
    }
  }

  Widget buildTopics(String name, Map data) {
    return ListTile(
      // key: Key(name),
      leading: const Icon(
        Icons.batch_prediction,
        color: Colors.amber,
      ),
      title: Center(
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      onTap: () {
        debugPrint("$name is the topic");
        Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionsPage(
                    data: data,
                    name: name,
                  ),
                ),
              );
      },
      shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25))),
      trailing: GestureDetector(
        child: Icon(
          Icons.delete_forever_rounded,
          color: Colors.red.shade600,
        ),
        onTap: () async {
          debugPrint("gay");
        },
      ),
    );
  }

  String urll = "";
  List<Widget> topics = [];
  Map masterTopicDict = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: topics.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: topics[index],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendGet,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}