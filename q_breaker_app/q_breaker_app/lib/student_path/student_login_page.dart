// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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
              SizedBox(
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
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) => 
                  Colors.green.shade200,
                  
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
                onPressed: () async {

                  String id = idController.text.trim();
                  String pin = pinController.text.trim();

                  showDialog(
                    context: context, 
                    builder: (context){
                      return  const Center(
                        child:  SpinKitChasingDots(
                          color: Colors.amber,
                          size: 60,
                          )
                        );
                    }
                    );
                  if (id.isNotEmpty && await fetchUserData(id, context.read<UserProvider>())){

                    final currentUser = Provider.of<UserProvider>(context,listen: false).currentUser;
                    if (pin == currentUser?['pin'].toString()){
                      //Removing the spinkit
                      Navigator.of(context).pop();
                      showDialog(
                        context: context, 
                        builder: (context){
                          Future.delayed(const Duration(seconds: 2),(){
                            Navigator.of(context).pop();
                          });
                          return AlertDialog(
                            backgroundColor: Colors.red.shade100,
                            
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Great, you are in'),
                                Icon(LineAwesomeIcons.thumbs_up_1, 
                                color: Colors.green, size: 100,),
                              ],
                            ),
                          );
                        }
                        );
                      //Navigating to home page.
                      Future.delayed(const Duration(seconds: 3),(){
                        Navigator.push(context,MaterialPageRoute(builder: (context) => const StudentPage()));
                      });
                    }
                    else{
                      //Removing the spinkit
                      Navigator.of(context).pop();
                      showDialog(
                        context: context, 
                        builder: (context){
                          Future.delayed(const Duration(seconds: 2),(){
                            Navigator.of(context).pop();
                          });
                          return AlertDialog(
                            backgroundColor: Colors.red.shade100,
                            
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Invalid Pin, try again...'),
                                Icon(LineAwesomeIcons.exclamation_circle, 
                                color: Colors.red, size: 50,),
                              ],
                            ),
                          );
                        }
                        );
                    }

                  }
                  else{
                    //Removing the spinkit
                    Navigator.of(context).pop();
                      showDialog(
                        context: context, 
                        builder: (context){
                          Future.delayed(const Duration(seconds: 2),(){
                            Navigator.of(context).pop();
                          });
                          return AlertDialog(
                            backgroundColor: Colors.red.shade100,
                            
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Student ID does not exist'),
                                Icon(LineAwesomeIcons.exclamation_circle, 
                                color: Colors.red, size: 50,),
                              ],
                            ),
                          );
                        }
                        );
                  }
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


