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
  @override
  void initState() {
    super.initState();
    widget.data.forEach((key, value) {
      questionCount++;
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
              // tileColor: selectedAnswers["q$questionCount"] == "a"
              //     ? Colors.amber
              //     : Colors.grey.shade200,
              onTap: () {
                // setState(() {
                //   notAnswered = false;
                //   selectedAnswers["q$questionCount"] = "a";
                // });
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
              // tileColor: selectedAnswers["q$questionCount"] == "b"
              //     ? Colors.amber
              //     : Colors.grey.shade200,
              // onTap: () {
              //   setState(() {
              //     notAnswered = false;

              //     selectedAnswers["q$questionCount"] = "b";
              //   });
              // },
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
              // tileColor: selectedAnswers["q$questionCount"] == "c"
              //     ? Colors.amber
              //     : Colors.grey.shade200,
              // onTap: () {
              //   setState(() {
              //     notAnswered = false;

              //     selectedAnswers["q$questionCount"] = "c";
              //   });
              // },
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
              // tileColor: selectedAnswers["q$questionCount"] == "d"
              //     ? Colors.amber
              //     : Colors.grey.shade200,
              // onTap: () {
              //   setState(() {
              //     notAnswered = false;
              //     selectedAnswers["q$questionCount"] = "d";
              //   });
              // },
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
                      if (questionCount >= 2) {
                        setState(() {
                          lastQuestion = false;

                          currentQuestion--;
                          // correctAnswerCount--;
                        });
                        // debugPrint(correctAnswerCount.toString());
                      } else {}
                    },
                    child: const Text('Prev question')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87),
                    onPressed: () {
                      if (questionCount <= 2) {
                        setState(() {
                          // notAnswered = false;
                          // if (selectedAnswers["q$questionCount"] ==
                          //     answers["q$questionCount"]) {
                          //   // correctAnswerCount++;
                          // }
                          if (questionCount == 2) {
                            setState(() {
                              lastQuestion = true;
                            });
                          }
                          currentQuestion++;
                        });
                        // debugPrint(correctAnswerCount.toString());
                      } else if (questionCount > 9) {
                        setState(() {
                          // notAnswered = false;
                        });
                        // if (selectedAnswers["q$questionCount"] ==
                        //     answers["q$questionCount"]) {
                        //   // correctAnswerCount++;
                        // }
                        // Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => ResultPage(
                        //           correctAnswerCount: correctAnswerCount)),
                        // );

                        // reInitalize();
                      } else {
                        setState(() {
                          // notAnswered = true;
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
