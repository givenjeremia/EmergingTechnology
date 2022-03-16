import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:projectuts_160419118_given/screen/quis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class Home extends StatelessWidget {
  final Widget rotate = Container();
  final Widget scale = Container();
  final Widget fade = Container();
  final Widget typer = Container();
  final Widget typeWriter = Container();
  final Widget wavy = Container();
  final Widget colorize = Container();
  final Widget textLiquidFill = Container();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        // appBar: AppBar(
        //   // title: Text('Home'),
        // ),
        body: Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: 20, height: 50),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 30,
                fontFamily: 'Horizon',
              ),
              child: AnimatedTextKit(animatedTexts: [
                RotateAnimatedText('ARE YOU READY ?'),
                RotateAnimatedText('ARE YOU SURE ?'),
                RotateAnimatedText('TRY THE QUIS NOW !'),
              ]),
            ),
          ],
        ),
        Divider(
          height: 3,
        ),
        FadeIn(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeIn,
          child: Container(
              height: size.height / 2,
              width: size.width,
              margin: EdgeInsets.all(20),
              // padding: EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
              decoration: BoxDecoration(
                color: Color(0xff88D8C7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "RULES GAME",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                    Divider(
                      height: 15,
                    ),
                    Text(
                      "1. Consists Of 5 Questions",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Text(
                      "2. Who Am I Themed Quiz",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Text(
                      "3. 10 Seconds Per Stage",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Divider(
                      height: 15,
                    ),
                    Text(
                      "RULES SCORE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                    Divider(
                      height: 15,
                    ),
                    Text(
                      "1. Stage 1 Get A Score 200",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Text(
                      "2. Stage 2 Get A Score 150",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Text(
                      "3. Stage 3 Get A Score 100",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Text(
                      "4. Stage 4 Get A Score 50",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Text(
                      "5. Stage 5 Get A Score 30",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Divider(
                      height: 5,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Quiz()));
                          },
                          child: Text("START QUIS")),
                    )
                  ],
                ),
              )),
        ),
      ],
    ));
  }
}
