import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../tema.dart';
import '../main.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TemaChanger>(
      create: (context) => TemaChanger(ThemeData.dark()),
      child: new MaterialAppWithTema(),
    );
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: _tema.getTema(),
    //   home: Login(),
    // );
  }
}

class MaterialAppWithTema extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Project UTS',
      theme: tema.getTema(),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  late String _user_id;
  void doLogin() async {
    //later, we use web service here to check the user id and password
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", _user_id);
    main();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Vens Quis'),
        ),
        body: SingleChildScrollView(
            child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/given.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                  height: size.height / 2,
                  child: Container(
                    child: RotateAnimatedTextKit(
                      text: ["  WELCOME  ", "  TO  ", "  VENS QUIS  "],
                      textStyle: TextStyle(
                          fontSize: 30.0,
                          backgroundColor: Color(0xff88D8C7),
                          color: Colors.black),
                      duration: Duration(seconds: 3),
                      isRepeatingAnimation: true,
                      repeatForever: true,
                    ),
                  )),
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xff88D8C7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.black,
                          filled: true,
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: 'Enter valid Username',
                          hintStyle: TextStyle(color: Colors.white)),
                      onChanged: (v) {
                        _user_id = v;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.black,
                          filled: true,
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: 'Enter secure password'),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: ElevatedButton(
                          onPressed: () {
                            doLogin();
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      )),
                ]),
              )
            ],
          ),
        )));
  }
}
