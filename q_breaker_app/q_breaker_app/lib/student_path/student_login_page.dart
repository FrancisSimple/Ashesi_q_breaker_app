import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:q_breaker_app/fetching_data.dart';
import 'package:q_breaker_app/student_path/student_page.dart';

class StudentLogIn extends StatefulWidget {
  const StudentLogIn({super.key});

  @override
  State<StudentLogIn> createState() => StudentLogInState();
}

class StudentLogInState extends State<StudentLogIn> {

  //controllers for the text fields
  TextEditingController idController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  //Log in validity method
  Future<void> checkLogin() async {
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar() ,
      body: SafeArea(child: 
        Container(
          color: Colors.blue.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
              height: 300,
              width: 300,

              child:  ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/qlogo.jpeg'))
              ),
              const SizedBox(height: 20),

              const Text('Enter your credentials',style: TextStyle(fontSize: 30),),
              const SizedBox(),

              //ID entry field
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  onChanged: (value){},
                  controller: idController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'Enter student ID',
                    label: const Text('Your ID goes here'),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    
                  ),
                ),
              ),
              const SizedBox(),

              //Pin entry field
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  onChanged: (value){},
                  controller: pinController,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'Enter PIN',
                    label: const Text('Your PIN goes here'),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    
                  ),
                ),
              ),
              const SizedBox(),

              //Enter button
              ElevatedButton(
                
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => 
                  Colors.green.shade200,
                  
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
                onPressed: () async {

                  String id = idController.text.trim();
                  String pin = pinController.text.trim();
                  if (await fetchUserData(id, context.read<UserProvider>())){

                    final currentUser = Provider.of<UserProvider>(context,listen: false).currentUser;
                    if (pin == currentUser?['pin']){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => StudentPage()));
                      print('success');
                    }
                    else{
                      print('Incorrect pin');
                    }

                  }
                  else{
                    print('student does not exist');
                  };
                }, 
                child: const Text('Enter to Break Q')
                ),
              const SizedBox(),

              //Row for issue report
               Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      //Navigate to help page
                    },
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text('Report an issue? ', style: TextStyle(color: Colors.blue),))
                    ),
                ],
              )
            ],
        ),)
      ),
    );
  }
}