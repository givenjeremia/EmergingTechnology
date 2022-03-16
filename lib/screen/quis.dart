import 'dart:async';
import 'dart:math';

// import '../screen/home.dart';
// import 'package:flutter_application_week6/screen/leaderboardquis.dart';
import 'package:projectuts_160419118_given/screen/leaderboardscore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

import '../class/question.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import '../main.dart';

String username = "";
Future<List<String>> checkTopScoreOne() async {
  final prefs = await SharedPreferences.getInstance();
  // List<String>? top_score = prefs.getStringList('top_one');
  return prefs.getStringList('top_one') ?? [];
}

Future<List<String>> checkTopScoreTwo() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('top_two') ?? [];
}

Future<List<String>> checkTopScoreThree() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? top_score = prefs.getStringList('top_three');
  return prefs.getStringList('top_three') ?? [];
}

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

class Quiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  late final controller;
  late int _hitung;
  late Timer _timer;
  double opacityLevel = 0;
  int soal_ke = 0;
  int _iniValue = 10;
  bool _isrun = false;
  int _question_no = 0;
  int _stage = 0;
  int _point = 0;
  int _top_one = 0;
  int _top_two = 0;
  int _top_three = 0;

  //Set Shared

  void setNewTopOne(List<String> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("top_one", data);
    main();
  }

  void setNewTopTwo(List<String> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("top_two", data);
    main();
  }

  void setNewTopThree(List<String> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("top_three", data);
    main();
  }

  void doRemove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    main();
  }

  String formatTime(int hitung) {
    var secs = hitung;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  finishQuiz() {
    _timer.cancel();
    _question_no = 0;
    //Pengecekan
    if (_point >= _top_three && _point < _top_two) {
      doRemove("top_three");
      List<String> data = ['$username', '$_point'];
      print("Pengecekan Three " + data.toString());
      setNewTopThree(data);
    } else if (_point >= _top_two && _point < _top_one) {
      doRemove("top_two");
      List<String> data = ['$username', '$_point'];
      print("Pengecekan Two " + data.toString());
      setNewTopTwo(data);
    } else if (_point >= _top_one) {
      doRemove("top_one");
      List<String> data = ['$username', '$_point'];
      print("Pengecekan one " + data.toString());
      setNewTopOne(data);
    }
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Quiz'),
              content: Text('Your point = ' + _point.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  void checkAnswer(String s) {
    setState(() {
      if (s == questions[_question_no].answer) {
        //Stage 1
        if (_stage == 0) {
          _point += 200;
        }
        //Stage 2
        else if (_stage == 1) {
          _point += 150;
        }
        //Stage 3
        else if (_stage == 2) {
          _point += 100;
        }
        //Stage 4
        else if (_stage == 3) {
          _point += 50;
        } else {
          _point += 30;
        }
        _stage = 0;
        soal_ke++;
        _question_no++;
      } else {
        if (_stage == questions[_question_no].picture.length - 1) {
          //Reset Stage
          _stage = 0;
          soal_ke++;
          _question_no++;
          print("IF " + _stage.toString());
          print(_question_no);
        } else {
          _stage++;
          print("ELSE " + _stage.toString());
        }
      }
      // _question_no++;
      print('----');
      //if (_q
      // if (_question_no > questions.length - 1) finishQuiz();
      if (soal_ke == 5) finishQuiz();
      //Cek Apakah Sudah Muncul 5 Soal
      _hitung = _iniValue;
    });
  }

  Fade() {
    setState(() {
      controller = FadeInController(autoStart: true);
    });
  }

  startTimer() {
    _timer = new Timer.periodic(new Duration(milliseconds: 1000), (timer) {
      setState(() {
        _hitung--;
        if (_hitung == 0) {
          print(_stage);
          if (_stage == questions[_question_no].picture.length - 1) {
            //Reset Stage
            _stage = 0;
            // _question_no++;
            soal_ke++;
          } else {
            _stage++;

            print("ELSE " + _stage.toString());
          }

          // if (_question_no > questions.length - 1) finishQuiz();
          if (soal_ke == 5) finishQuiz();
          //Cek Apakah Sudah Muncul 5 Soal

          _hitung = _iniValue;
        }
        _isrun = true;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    Fade();
    super.initState();
    checkUser().then((String result) {
      if (result == '') {
        username = "Kosong";
      } else {
        username = result;
      }
    });
    checkTopScoreOne().then((resultOne) {
      print(resultOne.length);
      if (resultOne.length == 0) {
        print("One Masuk");
        List<String> data = ['$username', '$_point'];
        setNewTopOne(data);
      } else {
        _top_one = int.parse(resultOne[1]);
        print("A " + _top_one.toString());
        checkTopScoreTwo().then((resultTwo) {
          print(resultTwo.length);
          if (resultTwo.length == 0) {
            print("Two Masuk");
            List<String> data = ['$username', '$_point'];
            setNewTopTwo(data);
          } else {
            _top_two = int.parse(resultTwo[1]);
            print("B " + _top_two.toString());
            checkTopScoreThree().then((resultThree) {
              if (resultThree.length == 0) {
                List<String> data = ['$username', '$_point'];
                setNewTopThree(data);
              } else {
                _top_three = int.parse(resultThree[1]);
                print("C " + _top_three.toString());
              }
            });
          }
        });
      }
    });
    _hitung = _iniValue;
    startTimer();
    controller.fadeIn();
    questions.add(QuestionObj(
        "Character name Is Iron Man, Who Is He ?",
        [
          'assets/images/1_STAGE_1.jpg',
          'assets/images/1_STAGE_2.jpg',
          'assets/images/1_STAGE_3.jpg',
          'assets/images/1_STAGE_4.jpg',
          'assets/images/1_STAGE_5.jpg'
        ],
        'Chris Evan',
        'Chris Hemsworth',
        'Robert Downey JR',
        'Mark Ruffalo',
        'Robert Downey JR'));
    questions.add(QuestionObj(
        "Samuel L Jackson In Avengers As ?",
        [
          'assets/images/2_STAGE_1.jpg',
          'assets/images/2_STAGE_2.jpg',
          'assets/images/2_STAGE_3.jpg',
          'assets/images/2_STAGE_4.jpg',
          'assets/images/2_STAGE_5.jpg'
        ],
        'Prof Hulf',
        'Nick Fury',
        'Loki',
        'Ahmad',
        'Nick Fury'));
    questions.add(QuestionObj(
        "Character Name Is Thor, Who is He?",
        [
          'assets/images/3_STAGE_1.jpg',
          'assets/images/3_STAGE_2.jpg',
          'assets/images/3_STAGE_3.jpg',
          'assets/images/3_STAGE_4.jpg',
          'assets/images/3_STAGE_5.jpg'
        ],
        'Chris Evan',
        'Chris Hemsworth',
        'Robert Downey JR',
        'Mark Ruffalo',
        'Chris Hemsworth'));
    questions.add(QuestionObj(
        "Jeremy Renner Is Avengers As?",
        [
          'assets/images/4_STAGE_1.jpg',
          'assets/images/4_STAGE_2.jpg',
          'assets/images/4_STAGE_3.jpg',
          'assets/images/4_STAGE_4.jpg',
          'assets/images/4_STAGE_5.jpg'
        ],
        'Prof Hulk',
        'Natasya',
        'Budi',
        'Hawkeye',
        'Hawkeye'));
    questions.add(QuestionObj(
        "Character Name Is Ant-Man, Who Is He ?",
        [
          'assets/images/5_STAGE_1.jpg',
          'assets/images/5_STAGE_2.jpg',
          'assets/images/5_STAGE_3.jpg',
          'assets/images/5_STAGE_4.jpg',
          'assets/images/5_STAGE_5.jpg',
        ],
        'Chris Evan',
        'Chris Hemsworth',
        'Paul Rudd',
        'Budi',
        'Paul Rudd'));
    //
    questions.add(QuestionObj(
        "Character name Is Black Widow, Who Is He ?",
        [
          'assets/images/6_STAGE_1.jpg',
          'assets/images/6_STAGE_2.jpg',
          'assets/images/6_STAGE_3.jpg',
          'assets/images/6_STAGE_4.jpg',
          'assets/images/6_STAGE_5.jpg'
        ],
        'Chris Evan',
        'Scarlett Johansson',
        'Paul Rudd',
        'Mark Ruffalo',
        'Scarlett Johansson'));
    questions.add(QuestionObj(
        "Character name Is Spiderman, Who Is He ?",
        [
          'assets/images/7_STAGE_1.jpg',
          'assets/images/7_STAGE_2.jpg',
          'assets/images/7_STAGE_3.jpg',
          'assets/images/7_STAGE_4.jpg',
          'assets/images/7_STAGE_5.jpg'
        ],
        'Tom Holland',
        'Chris Evan',
        'Loki',
        'Ahmad',
        'Tom Holland'));
    questions.add(QuestionObj(
        "Character Name Is Captain America, Who is He?",
        [
          'assets/images/8_STAGE_1.jpg',
          'assets/images/8_STAGE_2.jpg',
          'assets/images/8_STAGE_3.jpg',
          'assets/images/8_STAGE_4.jpg',
          'assets/images/8_STAGE_5.jpg'
        ],
        'Chris Evan',
        'Chris Hemsworth',
        'Robert Downey JR',
        'Mark Ruffalo',
        'Chris Evan'));
    questions.add(QuestionObj(
        "Character Name Is Captain Marvel, Who Is He?",
        [
          'assets/images/9_STAGE_1.jpg',
          'assets/images/9_STAGE_2.jpg',
          'assets/images/9_STAGE_3.jpg',
          'assets/images/9_STAGE_4.jpg',
          'assets/images/9_STAGE_5.jpg'
        ],
        'Prof Hulk',
        'Brie Larson',
        'Budi',
        'Hawkeye',
        'Brie Larson'));
    questions.add(QuestionObj(
        "Character Name Is Dominic Toretto, Who Is He ?",
        [
          'assets/images/10_STAGE_1.jpg',
          'assets/images/10_STAGE_2.jpg',
          'assets/images/10_STAGE_3.jpg',
          'assets/images/10_STAGE_4.jpg',
          'assets/images/10_STAGE_5.jpg'
        ],
        'Chris Evan',
        'Chris Hemsworth',
        'Vin Diesel',
        'Budi',
        'Vin Diesel'));
    questions.shuffle();
  }

  @override
  void dispose() {
    _timer.cancel();
    _hitung = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: LinearPercentIndicator(
                center: Text(formatTime(_hitung)),
                width: MediaQuery.of(context).size.width - 20,
                lineHeight: 20.0,
                percent: 1 - (_hitung / _iniValue),
                backgroundColor: Colors.grey,
                progressColor: Colors.blueAccent,
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Text('${soal_ke + 1}'),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        questions[_question_no].narration,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 25),
                      ),
                      Divider(
                        height: 10,
                      ),
                      Text("Stage : ${_stage + 1}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15)),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FadeIn(
                            child: Image.asset(
                                questions[_question_no].picture[_stage]),
                            // Optional paramaters
                            duration: Duration(milliseconds: 2000),
                            curve: Curves.easeIn,
                            controller: controller,
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          backgroundColor: Colors.white,
                          textStyle: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          checkAnswer(questions[_question_no].option_a);
                        },
                        child: Text("A. " + questions[_question_no].option_a,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            backgroundColor: Colors.white,
                            textStyle: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            checkAnswer(questions[_question_no].option_b);
                          },
                          child: Text("B. " + questions[_question_no].option_b,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                      TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            backgroundColor: Colors.white,
                            textStyle: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            checkAnswer(questions[_question_no].option_c);
                          },
                          child: Text("C. " + questions[_question_no].option_c,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                      TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            backgroundColor: Colors.white,
                            textStyle: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            checkAnswer(questions[_question_no].option_d);
                          },
                          child: Text("D. " + questions[_question_no].option_d,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                    ],
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
