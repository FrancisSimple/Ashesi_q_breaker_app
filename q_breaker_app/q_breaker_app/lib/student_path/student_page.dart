import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_breaker_app/fetching_data.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context,listen: false).currentUser;
    return  Scaffold(
      appBar: AppBar(
        
        leading: const Icon(Icons.list),
        title: Text('Welcome ${currentUser!['Name']}'),
        centerTitle: true,
        actions: const [ Icon(Icons.search)],
        backgroundColor: Colors.amber.shade400,
        bottom: const PreferredSize(preferredSize: Size.fromHeight(70), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Financial Status: MCF',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Total Amount',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text('GHC__ '),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Today\'s balance',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text('GHC__ '),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Daily Limit',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text('GHC__ '),
                ],
              ),
            ],),
          ],
        ),
        ),
      ),
      body: Center(child: Text('${currentUser['Name']} logs in.'),),
    );
  }
}