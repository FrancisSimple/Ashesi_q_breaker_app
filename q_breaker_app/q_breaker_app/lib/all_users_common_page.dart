// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:q_breaker_app/fetching_data.dart';
import 'package:q_breaker_app/student_path/student_selected_caf.dart';

//making a clickable cafeteria card.
//this is displayed on the student's home page.
class CaferiaCard extends StatelessWidget {
  const CaferiaCard({
    super.key,
    required this.name,
    required this.isOpen,
    required this.contact,
    required this.mealNumber,
  });

  //data field:
  // ignore: duplicate_ignore
  // ignore: prefer_typing_uninitialized_variables
  final name;
  final bool isOpen;
  // ignore: duplicate_ignore
  // ignore: prefer_typing_uninitialized_variables
  final contact;
  final mealNumber;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(
                  child: SpinKitChasingDots(
                color: Colors.amber,
                size: 60,
              ));
            });
        await Future.delayed(const Duration(milliseconds: 500));
        // ignore: use_build_context_synchronously
        if (isOpen &&
            await fetchCafData(
                name.replaceAll(' ', ''), context.read<CafProvider>())) {
          await Future.delayed(
              const Duration(milliseconds: 500)); // Delay for 100 milliseconds
          //Removing the spinkit
          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => const StudentSelectedCafeteria())));

          //Navigator.push(context, MaterialPageRoute(builder: ((context) => const StudentSelectedCafeteria())));
        } else {
          //Removing the spinkit
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pop();
                });
                return AlertDialog(
                  backgroundColor: Colors.red.shade100,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(isOpen
                          ? 'Entry access Granted'
                          : '$name is Closed at the moment'),
                      Icon(
                        isOpen
                            ? LineAwesomeIcons.check_circle
                            : LineAwesomeIcons.exclamation_circle,
                        color: isOpen ? Colors.green : Colors.red,
                        size: 50,
                      ),
                    ],
                  ),
                );
              });
        }
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
                    Text(
                      'Status: ${isOpen ? 'Open' : 'Closed'}',
                      style: TextStyle(
                        color: isOpen ? Colors.green : Colors.red,
                      ),
                    ),
                    Text('Meal Ready: $mealNumber'),
                    Text('Contact: $contact'),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

//making list tile for drawer
class MyListTile extends StatelessWidget {
  const MyListTile(
      {super.key,
      this.leadIcon,
      required this.title,
      this.trailing,
      this.function});

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
        onTap: function);
  }
}
//end of drawer list tile.

class MyFoodCard extends StatefulWidget {
  const MyFoodCard({super.key, required this.food});
  final Food food;

  @override
  State<MyFoodCard> createState() => _MyFoodCardState();
}

class _MyFoodCardState extends State<MyFoodCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            // Background image with some top padding
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(10.0), // Add rounded corners
                child: Image.asset(
                  'assets/qlogo.jpeg',
                  fit: BoxFit.cover, // Ensure image covers the entire container
                ),
              ),
            ),
            // Container for information with some top padding
            Positioned(
              top: 150.0, // Adjust padding as needed
              left: 0,
              right: 0,
              bottom: 20,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.blue
                      .withOpacity(0.8), // Semi-transparent background
                  borderRadius: BorderRadius.circular(
                      10.0), // Match corner radius of image
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Food information
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(widget.food.name),
                        const SizedBox(),
                        Text('GHC ${widget.food.price.toString()}'),
                      ],
                    ),
                    Text('Cost: ${widget.food.getNetCost()}'),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              widget.food.reduceQuantity();
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.red.withOpacity(0.9))),
                          child: const Icon(Icons.remove),
                        ),
                        Text(
                            'Quantity: ${widget.food.getQuantity()}'), // Update quantity based on state
                        TextButton(
                          onPressed: () {
                            setState(() {
                              widget.food.addToQuantity();
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.yellow.withOpacity(0.9))),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//end of food card

//starting the receipt card

class ReceiptCard extends StatefulWidget {
  const ReceiptCard({
    super.key,
    required this.newReceipt,
  });

  final Receipt newReceipt;
  @override
  State<ReceiptCard> createState() => _ReceiptCardState();
}

class _ReceiptCardState extends State<ReceiptCard> {
  @override
  Widget build(BuildContext context) {
    widget.newReceipt.generatePassword();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orange.withOpacity(0.7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Cafeteria: ${widget.newReceipt.caf}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            //student details
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Student name',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.newReceipt.studentName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(width: 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Student ID',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.newReceipt.getStudentId().toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const Text('------------------------------'),
            const SizedBox(),

            //listing receipt food content
            for (Food food in widget.newReceipt.foods)
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(food.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Unit Price',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(food.getPrice().toString()),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Quantity',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(food.getQuantity().toString()),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Cost',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(food.getNetCost().toString()),
                          ],
                        ),
                      ],
                    ),
                    const Text('--'),
                  ],
                ),
              ),
            Container(
                alignment: Alignment.centerRight,
                child: Text(
                    'Total Cost: ${widget.newReceipt.getTotalCost().toString()}')),

            Text('Receipt Password: ${widget.newReceipt.getPassword()}')
          ],
        ),
      ),
    );
  }
}

//end of receipt card
