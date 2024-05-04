
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


//making a clickable cafeteria card.
//this is displayed on the student's home page.
class CaferiaCard extends StatelessWidget {
  const CaferiaCard({super.key,
    required this.name,
    required this.isOpen,
    required this.contact,
    required this.mealNumber,
  });

  //data field:
  final name;
  final bool isOpen;
  final contact;
  final mealNumber;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showDialog(
          context: context, 
          builder: (context){
            Future.delayed(Duration(seconds: 2),(){
              Navigator.of(context).pop();
            });
            return AlertDialog(
              backgroundColor: Colors.red.shade100,
              
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Text(isOpen ? 'Entry access Granted' : 'Cafeteria is Closed at the moment'),
                  Icon(isOpen ? LineAwesomeIcons.check_circle : LineAwesomeIcons.exclamation_circle, 
                  color: isOpen ? Colors.green : Colors.red, size: 50,),
                ],
              ),
            );
          }
          );
      },
      child: SizedBox(
        height: 500,
        width: 400,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset('assets/qlogo.jpeg'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Text('Status: ${isOpen ? 'Open': 'Closed'}',style: TextStyle(
                  color: isOpen ? Colors.green : Colors.red,
                ),),
                Text('Meal Ready: $mealNumber'),
                Text('Contact: $contact'),
        
              ],)
            ],
          )
        ),
      ),
    );
  }
}

//making list tile for drawer
class MyListTile extends StatelessWidget {
  const MyListTile({super.key,
              this.leadIcon,
              required this.title,
              this.trailing,
              this.function
  });

  final Icon? leadIcon;
  final String title;
  final Icon? trailing;
  final VoidCallback? function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
              //leading (Usually an icon)
                leading: leadIcon,
              //title
                title: Text(title),
              //trailing
                trailing: trailing,
              //onTap function
              onTap: function
              );
  }
}
//end of drawer list tile.