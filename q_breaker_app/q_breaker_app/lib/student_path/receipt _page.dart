// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_breaker_app/all_users_common_page.dart';
import 'package:q_breaker_app/fetching_data.dart';
import 'package:q_breaker_app/student_path/student_selected_caf.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({
    super.key,
    required this.receipt,
  });
  final Receipt receipt;
  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<UserProvider>(context, listen: true).currentUser;
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
                    TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      )),
                      child: const Text('Reset'),
                    ),

                    //approve receipt button
                    TextButton(
                      onPressed: () async {
                        final userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        currentUser!.addReceipt(widget.receipt);
                        await userProvider.updateDatabaseReceipts(
                            currentUser.id, currentUser.receiptList);
                        for (Food food in widget.receipt.foods) {
                          food.resetQuantity();
                        }
                        await fetchUserData(currentUser.id.toString(),
                            context.read<UserProvider>());
                        setState(() {});
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    const StudentSelectedCafeteria())));
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.green.withOpacity(0.6),
                      )),
                      child: const Text('Purchase'),
                    ),

                    //continue manipulating receipt inputs.
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    const StudentSelectedCafeteria())));
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.yellow.withOpacity(0.6),
                      )),
                      child: const Text('Continue'),
                    ),
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
