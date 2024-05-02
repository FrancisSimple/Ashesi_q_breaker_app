

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:q_breaker_app/student_path/student_login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue.shade100,
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock,size: 50,),
            const SizedBox(height: 20),
            const Text('Welcome Q-Breaker',style: TextStyle(fontSize: 25),),
            const SizedBox(height: 20),
            Container(
              height: 300,
              width: 300,

              child:  ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/qlogo.jpeg'))
              ),
            const SizedBox(height: 20),
            const Text('Pick your hammer',style: TextStyle(fontSize: 25),),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Column(
                children: [
                  IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentLogIn()));
                  },
                  icon: const Icon(LineAwesomeIcons.hammer,size: 45,)),
                  const Text('Student',style: TextStyle(fontSize: 20),),
                ],
              ),
              Column(
                children: [
                  IconButton(onPressed: (){}, icon: const Icon(LineAwesomeIcons.hammer,size: 45,)),
                  const Text('Admin',style: TextStyle(fontSize: 20),),
                ],
              ),
              Column(
                children: [
                  IconButton(onPressed: (){}, icon: const Icon(LineAwesomeIcons.hammer,size: 45,)),
                  const Text('Cafeteria',style: TextStyle(fontSize: 20),),
                ],
              ),
              
            ],),
            

        
          ],
        ),
      ),
    );
  }
}