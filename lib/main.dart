import 'package:flutter/material.dart';
import 'package:projectuts_160419118_given/screen/leaderboardscore.dart';
import 'package:projectuts_160419118_given/screen/quis.dart';
import 'package:projectuts_160419118_given/tema.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/home.dart';
import 'screen/leaderboardscore.dart';
import 'screen/login.dart';
import 'tema.dart';

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TemaChanger>(
      create: (context) => TemaChanger(ThemeData.dark()),
      child: new MaterialAppWithTema(),
    );
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: MyHomePage(title: 'Flutter Demo Home Page'),
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
        home: MyHomePage(title: 'Venz Quis'),
        routes: {
          'leaderboardscore': (context) => LeaderboardScore(),
          'quis': (context) => Quiz(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _currentIndex = 0;
  final List<Widget> _screens = [Home(), LeaderboardScore()];
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    main();
  }

  void doRemoveLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("top_one");
    prefs.remove("top_two");
    prefs.remove("top_three");
    main();
  }

  Widget myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(active_user),
              accountEmail: Text("$active_user@gmail.com"),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150"))),
          ListTile(
              title: new Text("Start Quis"),
              leading: new Icon(
                Icons.quiz_sharp,
                size: 40,
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, "quis");
              }),
          ListTile(
              title: new Text("Leaderboard Quis"),
              leading: new Icon(Icons.leaderboard, size: 40),
              onTap: () {
                Navigator.popAndPushNamed(context, "leaderboardscore");
              }),
          ListTile(
              title: new Text("Reset Leaderboard"),
              leading: new Icon(Icons.leaderboard, size: 40),
              onTap: () {
                doRemoveLeaderboard();
              }),
          Divider(color: Colors.white, height: 5),
          ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
              onTap: () {
                doLogout();
              })
        ],
      ),
    );
  }

  Widget nav() {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Colors.pinkAccent,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(
              Icons.home,
              size: 40,
            ),
          ),
          BottomNavigationBarItem(
            label: "Leaderboard Score",
            icon: Icon(Icons.leaderboard),
          ),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _screens[_currentIndex],
      drawer: myDrawer(),
      bottomNavigationBar:
          nav(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
