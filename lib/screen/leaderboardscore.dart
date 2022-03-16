import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:projectuts_160419118_given/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> checkTopScoreOne() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('top_one') ?? [];
}

Future<List<String>> checkTopScoreTwo() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('top_two') ?? [];
}

Future<List<String>> checkTopScoreThree() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('top_three') ?? [];
}

class LeaderboardScore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LeaderboardScore();
  }
}

class _LeaderboardScore extends State<LeaderboardScore> {
  String topOne = "";
  String topTwo = "";
  String topThree = "";
  bool isChanged = false;
  bool textA = false;
  late Timer _timer;
  Display() {
    //Top One
    checkTopScoreOne().then((resultOne) {
      setState(() {
        if (resultOne.length == 0) {
          topOne = "";
        } else {
          topOne = "Username: ${resultOne[0]}\nScore: ${resultOne[1]}";
        }
      });
    });
    //Top Two
    checkTopScoreTwo().then((resultTwo) {
      setState(() {
        if (resultTwo.length == 0) {
          topTwo = "";
        } else {
          topTwo = "Username: ${resultTwo[0]}\nScore: ${resultTwo[1]}";
        }
      });
    });
    //Top Three
    checkTopScoreThree().then((resultThree) {
      setState(() {
        if (resultThree.length == 0) {
          topThree = "";
        } else {
          topThree = "Username: ${resultThree[0]}\nScore: ${resultThree[1]}";
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = new Timer.periodic(new Duration(milliseconds: 100), (timer) {
      setState(() {
        isChanged = true;
        textA = !textA;
      });
    });

    Display();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    Size size = MediaQuery.of(context).size;
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 50.0,
      fontFamily: 'Horizon',
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Leaderboard Quis',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'Congratulation',
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                ),
              ],
              isRepeatingAnimation: true,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: isChanged ? size.width : 100,
              height: isChanged ? size.height / 2 : 100,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(top: 20, bottom: 20, left: 0, right: 0),
              decoration: BoxDecoration(
                // color: Color(0xff88D8C7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                color: isChanged ? Color(0xff88D8C7) : Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/TropyOne.png", height: 100),
                      Text(
                        topOne,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20),
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/TropyTwo.png", height: 75),
                      Text(
                        topTwo,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 17),
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/TropyThree.png", height: 50),
                      Text(
                        topThree,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
