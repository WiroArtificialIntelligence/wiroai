import 'package:flutter/material.dart';
import 'package:wiroai/screens/intro_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  _resetSharedPreferences();
  runApp(const MainApp());
}

Future<void> _resetSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // print(prefs.getKeys());
  // await prefs.clear(); // Clear all data from SharedPreferences !! Only uncomment for debug purpose
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IntroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
