import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:q_breaker_app/all_users_common_page.dart';
import 'package:q_breaker_app/fetching_data.dart';

class StudentPage extends StatefulWidget {
   const StudentPage({super.key});
  

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final List cards =[
    const Center(child: CaferiaCard(name: 'Big Ben',mealNumber: '6',isOpen: true,contact: 'Akonor Down',),),
    const Center(child: CaferiaCard(name: 'Akornor',mealNumber: '2',isOpen: true,contact: 'Akonor Down',),),
    const Center(child: CaferiaCard(name: 'Munchies',mealNumber: '5',isOpen: true,contact: 'Akonor Down',),),
    const Center(child: CaferiaCard(name: 'Essentials',mealNumber: '2',isOpen: false,contact: 'Akonor Down',),),
  ];
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context,listen: false).currentUser;
    return  Scaffold(
      appBar: AppBar(      
        title: Text('Welcome ${currentUser!['Name']}'),
        centerTitle: true,
        actions: const [ Icon(Icons.search)],
        backgroundColor: Colors.amber.shade400,
        bottom:  PreferredSize(preferredSize: const Size.fromHeight(70), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Financial Status: ${currentUser['status']}',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Total Amount',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text('GHC ${currentUser['Account balance'].toString()}'),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Today\'s balance',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text('GHC ${currentUser['Today\'s balance'].toString()}'),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Daily Limit',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text('GHC: ${currentUser['Daily Limit'].toString()}'),
                ],
              ),
            ],),
          ],
        ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blue.shade50,
          child: ListView(
            
            children: const [
              Center(child: DrawerHeader(child: Text("Q-Breaker"))),
              //MyListTile(title: '', leadIcon: Icon(LineAwesomeIcons.phone_volume),),
              //SizedBox(height: 15),
              MyListTile(title: 'Account Details', leadIcon: Icon(LineAwesomeIcons.person_entering_booth),),
              SizedBox(height: 15),
              MyListTile(title: 'Pending receipts', leadIcon: Icon(LineAwesomeIcons.truck_loading),),
              SizedBox(height: 15),
              MyListTile(title: 'Meal History', leadIcon: Icon(LineAwesomeIcons.history),),
              SizedBox(height: 15),
              MyListTile(title: 'Change Pin', leadIcon: Icon(LineAwesomeIcons.phone_square),),
              SizedBox(height: 15),
              MyListTile(title: 'Contact Support Centre', leadIcon: Icon(LineAwesomeIcons.phone_volume),),
              SizedBox(height: 15),
              MyListTile(title: 'Log out', leadIcon: Icon(LineAwesomeIcons.alternate_sign_out),),
            ],
          )
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Text('Cafeterias', style:TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(child:
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.separated(
                itemCount: cards.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: 20),
                itemBuilder: (context,index){
                  return cards[index];
                }),
            )
          ),
        ],
      ),
    );
  }
}