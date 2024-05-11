// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_breaker_app/all_users_common_page.dart';
import 'package:q_breaker_app/fetching_data.dart';
import 'package:q_breaker_app/student_path/student_selected_caf.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key,
                    required this.receipt,
  });
  final Receipt receipt;
  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  


  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context,listen: false).currentUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                ReceiptCard(newReceipt: widget.receipt),
                const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //reset button
                    TextButton(onPressed: (){},style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white,)
                    ), child: const Text('Reset'),),
          
                    //approve receipt button
                    TextButton(onPressed: () async{
                      currentUser!.addReceipt(widget.receipt);
                      currentUser.updateDatabaseReceipts(currentUser['Today\'s balance'] - widget.receipt.getTotalCost());
                      await fetchUserData(currentUser.id.toString(), context.read<UserProvider>());
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => StudentSelectedCafeteria())));
                    }, style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green.withOpacity(0.6),)
                    ),child: const Text('Purchase'),),
          
                    //continue manipulating receipt inputs.
                    TextButton(onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => StudentSelectedCafeteria())));
                    },style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow.withOpacity(0.6),)
                    ), child: const Text('Continue'),),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}