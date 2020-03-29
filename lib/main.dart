import 'package:campsite/screens/home.dart';
import 'package:campsite/screens/welcome.dart';
import 'package:campsite/util/test.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campsite',
      theme: ThemeData.dark(),
      home: SafeArea(
          child: WelcomeScreen()),
      // home: SafeArea(child: Test()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position position;

  getLocation() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude);
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Container());
  }
}
