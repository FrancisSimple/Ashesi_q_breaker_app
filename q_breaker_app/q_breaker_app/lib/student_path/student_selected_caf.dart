import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_breaker_app/all_users_common_page.dart';
import 'package:q_breaker_app/fetching_data.dart';

class StudentSelectedCafeteria extends StatefulWidget {
  const StudentSelectedCafeteria({super.key});

  @override
  State<StudentSelectedCafeteria> createState() => _StudentSelectedCafeteriaState();
}

class _StudentSelectedCafeteriaState extends State<StudentSelectedCafeteria> {

  double currentCost = 0;
  
  @override
  void initState() {
    super.initState();
    final currentCaf = Provider.of<CafProvider>(context, listen: false).currentUser;
    currentCaf!.addFood('Plain Rice and chicken', 20);
    currentCaf.addFood('Omutuo', 25);
    currentCaf.addFood('Banku with okro', 30);
    currentCaf.addFood('Spaghetti', 25);
  }

  @override
  Widget build(BuildContext context) {
    

    final currentUser = Provider.of<UserProvider>(context,listen: false).currentUser;
    final currentCaf = Provider.of<CafProvider>(context,listen: false).currentUser;
    double potentialRemainder = currentUser!['Today\'s balance'] - currentCost;
    
    

    
    return Scaffold(
      appBar: AppBar(      
        title: Text('Thank you for selecting ${currentCaf!['name']?? 'Loading'}'),
        centerTitle: true,
        actions: const [ Icon(Icons.search)],
        backgroundColor: Colors.amber.shade400,
        bottom:  PreferredSize(preferredSize: const Size.fromHeight(100), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Day value',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text('GHC ${currentUser['Today\'s balance'].toString()}'),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Food cost',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text('GHC ${currentCost.toString()}'),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('To remain',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text('GHC: ${potentialRemainder.toString()}'),
                ],
              ),
            ],
            ),
            //end of account balance row

            //submit buttons row
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: (){
                  double totalCost = 0;
                  for(Food food in currentCaf.foods){
                    totalCost += food.getNetCost();
                  }
                  setState(() {
                      currentCost =totalCost;
                      print(currentCost);
                      }
                        ); 
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.9))),
                   child: const Text('Evaluate cost',style: TextStyle(color: Colors.white),),
                  
                  ),
                  TextButton(onPressed: (){
                    double totalCost = 0;
                    for(Food food in currentCaf.foods){
                      totalCost += food.netCost;
                    }
                    setState(() {
                      currentCost = totalCost;
                    });
                    issueReceipt(currentUser['Today\'s balance'], currentCost, currentCaf.foods, currentUser['Name'], currentCaf['name'], currentUser['id']);
                  },style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green.withOpacity(0.9))), child: const Text('Get Receipt')),
                ],
              ),
            )
          ],
        ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          //height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              for(Food food in currentCaf.foods)
                MyFoodCard(food: food),
               
            ],
          ),
        ),
      ),

      
    );
  }
  //End of the build method

  //method for evaluation receipt:
  void issueReceipt(double currentBalance, double evaluatedCost, List<Food> foodList,String studentName,String cafName,int studentId){
    List<Food> foodsToBuy = [];
    Receipt newReceipt;
    //get number of items selected
    for (Food food in foodList){
      if (food.getNetCost() != 0){
        foodsToBuy.add(food);
      }
      

    }
    double remainder = currentBalance - evaluatedCost;
    //these two conditions must be met to purchase
    if (remainder >= 0 && foodsToBuy.isNotEmpty){

        newReceipt = Receipt(foods: foodsToBuy, caf: cafName, studentName: studentName, studentId: studentId);
        showDialog(
          context: context, 
          builder: (context){
            // Future.delayed(const Duration(seconds: 2),(){
            //   Navigator.of(context).pop();
            // });
            return AlertDialog(
              backgroundColor: Colors.red.shade100,
              
              content: ReceiptCard(newReceipt: newReceipt),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                  for (Food food in foodList){
                    setState(() {
                      food.netCost = 0;
                      food.quantity = 0;
                      evaluatedCost = 0;
                      foodList =[];
                    });
                  }
                }, 
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white)), 
                child: const Text('Reset'),),

                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, 
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)), 
                child: const Text('Go back'),),

                TextButton(onPressed: (){}, 
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)), 
                child: const Text('Order'),),
              ],
            );
          }
          );
    }

    else if(remainder < 0 && foodsToBuy.isNotEmpty){
      showPopup(context, 'Insufficient balance');
    }
    else if(remainder >= 0 && foodsToBuy.isEmpty){
      showPopup(context, 'You have no food yet selected');
    }
  }

  //end of issue receipt method


  void showPopup(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Handle action button tap
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}



  
