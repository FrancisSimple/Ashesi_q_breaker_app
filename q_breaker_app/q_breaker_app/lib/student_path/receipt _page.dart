import 'package:flutter/material.dart';
import 'package:q_breaker_app/all_users_common_page.dart';
import 'package:q_breaker_app/fetching_data.dart';

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
    return Scaffold(
      appBar: AppBar(),
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
                    TextButton(onPressed: (){}, style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green.withOpacity(0.6),)
                    ),child: const Text('Purchase'),),
          
                    //continue manipulating receipt inputs.
                    TextButton(onPressed: (){},style: ButtonStyle(
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