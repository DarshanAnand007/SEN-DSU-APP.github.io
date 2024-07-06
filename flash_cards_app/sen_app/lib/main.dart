import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sen_app/questionspage.dart';
import 'package:sen_app/studentpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StudentPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title, required this.name, required this.data});
  final String name;
  final Map data;
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget buildTopics(String name, Map<String, dynamic> data) {
    return ListTile(
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
          bottomLeft: Radius.circular(25),
        ),
      ),
      trailing: GestureDetector(
        child: Icon(
          Icons.arrow_forward,
          color: Colors.red.shade600,
        ),
        onTap: () async {
          debugPrint("arrow forward tapped");
        },
      ),
    );
  }

  String urll = "";
  List<Widget> topics = [];
  Map masterTopicDict = {};

  @override
  void initState() {
    super.initState();
    Map data = widget.data;
    List<Widget> temptopics = [];

    if (data != null && data.containsKey("ids")) {
      for (var id in data["ids"]) {
        debugPrint('Processing id: $id');
        if (data[id] != null && data[id].containsKey('content')) {
          Map<String, dynamic>? contentData = data[id]['content'];
          if (contentData != null &&
              contentData.containsKey('names') &&
              contentData.containsKey('topics')) {
            for (var topicName in contentData['names']) {
              debugPrint('Processing topic: $topicName');
              Map<String, dynamic>? topicContent =
                  contentData['topics'][topicName];
              if (topicContent != null) {
                temptopics.add(buildTopics(topicName, topicContent));
              } else {
                debugPrint('Topic content is null for topic: $topicName');
              }
            }
          } else {
            debugPrint(
                'Content data is missing names or topics key for id: $id');
          }
        } else {
          debugPrint('Data for id $id does not contain content or is null');
        }
      }
    } else {
      debugPrint('Data does not contain ids key or is null');
    }

    setState(() {
      topics.addAll(temptopics);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
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
    );
  }
}
