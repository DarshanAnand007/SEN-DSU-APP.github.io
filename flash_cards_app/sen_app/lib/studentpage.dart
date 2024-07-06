import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sen_app/main.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  Future<void> sendGet() async {
    List<Widget> tempDocuments = [];
    final Uri url = Uri.parse('http://192.168.245.71:5000/getData');
    try {
      // Send the GET request
      final response = await http.get(url).timeout(const Duration(seconds: 24));

      // Check for a successful response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint(response.body);
        for (var id in data['ids']) {
          tempDocuments.add(buildDocuments(data[id]["name"], data[id]));
        }
      } else {
        // Handle non-successful response
        debugPrint('Request failed with status: ${response.statusCode}');
      }
      setState(() {
        topics.addAll(tempDocuments);
      });
    } catch (e) {
      // Handle any errors that occur
      debugPrint('Error occurred: $e');
    }
  }

  final Dio _dio = Dio();
  // ignore: unused_field
  bool _isUploading = false;
  // ignore: unused_field
  String _message = '';

  Future<void> _pickFileAndUpload() async {
    int uploadedSize = 0;
    int totalSize = 1;
    // Pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        // Prepare the file
        String filePath = result.files.single.path!;
        String fileName = result.files.single.name;
        debugPrint(filePath);
        debugPrint(fileName);

        FormData formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(filePath, filename: fileName),
        });
        List<Widget> tempDocuments = [];

        // Send the file to the server
        Response response = await _dio.post(
          'http://192.168.245.71:5000/get_document', // Replace with your Flask server URL
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          ),
          onSendProgress: (int sent, int total) {
            // Calculate and print the upload progress
            setState(() {
              totalSize = total;
              uploadedSize = sent;
            });
            double progress = sent / total * 100;
            debugPrint('Upload progress: ${progress.toStringAsFixed(2)}%');
          },
        );

        setState(() {
          _message = 'File uploaded successfully: ${response.data}';
        });

        final data = jsonDecode(response.data);
        debugPrint(response.data);
        for (var id in data['ids']) {
          tempDocuments.add(buildDocuments(data[id]["name"], data[id]));
        }

        setState(() {
          topics.addAll(tempDocuments);
        });
      } catch (e) {
        setState(() {
          _message = 'File upload failed: $e';
        });
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    } else {
      setState(() {
        _message = 'No file selected';
      });
    }
  }

  Widget buildDocuments(String name, Map data) {
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
            builder: (context) => MyHomePage(
              data: data,
              name: name,
              title: name,
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
          Icons.arrow_forward,
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
        title: const Center(child: Text("Documents")),
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
        onPressed: _pickFileAndUpload,
        tooltip: 'Increment',
        child: const Icon(Icons.upload_file),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
