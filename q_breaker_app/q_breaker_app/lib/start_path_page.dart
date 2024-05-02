import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:q_breaker_app/homepage.dart';
import 'package:q_breaker_app/welcome.dart';
class StartPath extends StatefulWidget {
  const StartPath({super.key});

  @override
  State<StartPath> createState() => _StartPathState();
}

class _StartPathState extends State<StartPath> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const HomePage();
          }
          else{
            return const WelcomePage();
          }
        }
        ));
  }
}