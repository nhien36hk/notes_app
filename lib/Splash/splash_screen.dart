import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes_app/Constants/constant.dart';
import 'package:notes_app/Screens/home_screen.dart';
import 'package:notes_app/Screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void startTimer() async {
    Timer(Duration(seconds: 2), () async {
      if(firebaseAuth.currentUser != null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFC4C4C4),
      body: Center(
        child: Text(
          "Notes App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
  }
}
