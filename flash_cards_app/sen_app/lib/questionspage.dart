import 'package:flutter/material.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key, required this.name, required this.data});
  final String name;
  final Map data;
  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  int questionCount = 0;
  int currentQuestion = 1;
  bool lastQuestion = false;
  Map answered = {
    "1": {"answered": false, "answer": 0},
    "2": {"answered": false, "answer": 0},
    "3": {"answered": false, "answer": 0},
    "4": {"answered": false, "answer": 0},
  };

  @override
  void initState() {
    super.initState();
    widget.data["answered"] = [];
    widget.data.forEach((key, value) {
      questionCount++;
      widget.data["answered"].add([false, 0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Text(
                  "$currentQuestion. ${widget.data["$currentQuestion"]["question"]}",
                  style: const TextStyle(fontSize: 30),
                  maxLines:
                      null, // Allows text to expand as many lines as needed
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text("Diffculty level : "),
                Text(
                  "${widget.data["$currentQuestion"]["difficultylevels"]}",
                  style: TextStyle(
                      color: widget.data["$currentQuestion"]
                                  ["difficultylevels"] ==
                              "hard"
                          ? Colors.red
                          : Colors.green),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              minLeadingWidth: 20,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade600, width: 1),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.elliptical(16, 16),
                      topRight: Radius.elliptical(16, 16),
                      bottomRight: Radius.elliptical(16, 16),
                      bottomLeft: Radius.elliptical(16, 16))),
              tileColor: answered["$currentQuestion"]["answered"] == true &&
                      answered["$currentQuestion"]["answer"] == 0
                  ? Colors.amber
                  : Colors.grey.shade200,
              onTap: () {
                // debugPrint(widget.data["a"]);
                setState(() {
                  answered["$currentQuestion"]["answered"] = true;
                  answered["$currentQuestion"]["answer"] = 0;
                });
              },
              leading: Container(
                  width: 25,
                  height: 25,
                  // alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black87),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Center(
                      child: Text(
                        "A",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              title: Text(widget.data["$currentQuestion"]["options"][0]),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              minLeadingWidth: 20,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade600, width: 1),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.elliptical(16, 16),
                      topRight: Radius.elliptical(16, 16),
                      bottomRight: Radius.elliptical(16, 16),
                      bottomLeft: Radius.elliptical(16, 16))),
              tileColor: answered["$currentQuestion"]["answered"] == true &&
                      answered["$currentQuestion"]["answer"] == 1
                  ? Colors.amber
                  : Colors.grey.shade200,
              onTap: () {
                // debugPrint(widget.data["a"]);
                setState(() {
                  answered["$currentQuestion"]["answered"] = true;
                  answered["$currentQuestion"]["answer"] = 1;
                });
              },
              leading: Container(
                  width: 25,
                  height: 25,
                  // alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black87),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Center(
                      child: Text(
                        "B",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              title: Text(widget.data["$currentQuestion"]["options"][1]),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              minLeadingWidth: 20,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade600, width: 1),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.elliptical(16, 16),
                      topRight: Radius.elliptical(16, 16),
                      bottomRight: Radius.elliptical(16, 16),
                      bottomLeft: Radius.elliptical(16, 16))),
              tileColor: answered["$currentQuestion"]["answered"] == true &&
                      answered["$currentQuestion"]["answer"] == 2
                  ? Colors.amber
                  : Colors.grey.shade200,
              onTap: () {
                // debugPrint(widget.data["a"]);
                setState(() {
                  answered["$currentQuestion"]["answered"] = true;
                  answered["$currentQuestion"]["answer"] = 2;
                });
              },
              leading: Container(
                  width: 25,
                  height: 25,
                  // alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black87),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Center(
                      child: Text(
                        "C",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              title: Text(widget.data["$currentQuestion"]["options"][2]),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              minLeadingWidth: 20,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade600, width: 1),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.elliptical(16, 16),
                      topRight: Radius.elliptical(16, 16),
                      bottomRight: Radius.elliptical(16, 16),
                      bottomLeft: Radius.elliptical(16, 16))),
              tileColor: answered["$currentQuestion"]["answered"] == true &&
                      answered["$currentQuestion"]["answer"] == 3
                  ? Colors.amber
                  : Colors.grey.shade200,
              onTap: () {
                // debugPrint(widget.data["a"]);
                setState(() {
                  answered["$currentQuestion"]["answered"] = true;
                  answered["$currentQuestion"]["answer"] = 3;
                });
              },
              leading: Container(
                  width: 25,
                  height: 25,
                  // alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black87),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Center(
                      child: Text(
                        "D",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              title: Text(widget.data["$currentQuestion"]["options"][3]),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: notAnswered
          //       ? const Text(
          //           'Choose an option first!',
          //           style: TextStyle(color: Colors.red),
          //         )
          //       : const Text(''),
          // ),

          //
          const Expanded(child: SizedBox()),

          //
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87),
                    onPressed: () {
                      if (currentQuestion > 1) {
                        setState(() {
                          currentQuestion--;
                        });
                      }
                    },
                    child: const Text('Prev question')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87),
                    onPressed: () {
                      if (currentQuestion < 3) {
                        setState(() {
                          currentQuestion++;
                        });
                      }
                    },
                    child: Text(lastQuestion ? 'Submit' : 'Next question')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
