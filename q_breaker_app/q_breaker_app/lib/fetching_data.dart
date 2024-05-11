

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//Student class

class User {

//data fields
  int id;
  //Map<String,dynamic> data;
  String  name;
  String status;
  List<Receipt>? receiptList;
  int pin;
  bool accountStatus;
  Map<String, dynamic>? data;
  dynamic operator [](String key) => data![key];
  double todayBalance = 0;

//end of data field


//constructor
  User({required this.id,required this.name,required this.pin, required this.accountStatus, this.receiptList,required this.status,this.data});

  

  void setTodayBalance(){
    todayBalance = this['Today\'s balance'];
  }


  bool changedPin(int oldPin, int newPin){

    pin = (pin == oldPin) ? newPin: oldPin;

    return (newPin == pin) ? true:false;
  }

  //add receipt to the list
  void addReceipt(Receipt receipt){
    receiptList!.add(receipt);
  }

  String getFinancialStatus(){
    return status;
  }




  Future<bool> updateDatabaseReceipts(double change) async {
    
    List databaseReceiptArray = [];
    for(Receipt receipt in receiptList!){
      List databaseFoodArray =[];

      for (Food food in receipt.foods){

        Map<String, dynamic> databaseFood ={
          'foodName': food.name,
          'quantity': food.quantity,
          'unitPrice': food.price,

        };
        databaseFoodArray.add(databaseFood);
      }

      Map<String, dynamic> databaseReceipt ={

        'cafeteriaName': receipt.getCafName(),
        'isActive': receipt.isActive,
        'password': receipt.getPassword(),
        'studentId': receipt.getStudentId(),
        'studentName': receipt.getStudentName(),
        'foods': databaseFoodArray,        
      };

      databaseReceiptArray.add(databaseReceipt);


    }

    DocumentReference docRef = FirebaseFirestore.instance.collection('students').doc(id.toString());
    print(docRef);
    await docRef.update({

      'receipts': databaseReceiptArray,
      'Today\'s balance': change,

    });
    
    
    return true;
  }


}
//end of student class



//creating a cafeteria class
class Caf {

  //data fields
  final String id;
  final Map<String,dynamic> data;
  List<Food> foods = [];

  //constructor
  Caf({required this.id,required this.data});

  //for storage of user fields.
  dynamic operator [](String key) => data[key];

  //used to add a new food to menu
  void addFood(String name, double price){
    foods.add(Food(price: price, name: name));
  }

}
//end of cafeteria class


//this is the cafeteria provider to use in the code.
class CafProvider extends ChangeNotifier{

  Caf? _currentUser;

  Caf? get currentUser => _currentUser;

  void setCurrentUser(Caf user){

    _currentUser = user;
    notifyListeners();

  }

}
//end of provider for cafeteria

//Provider class for student data
class UserProvider extends ChangeNotifier{

  User? _currentUser;

  User? get currentUser => _currentUser;

  void setCurrentUser(User user){

    _currentUser = user;
    notifyListeners();

  }

}


Future<void> createStudent(String name,int studentId, String pin, String financialStatus) async{

  //creating user with email and password using firebase authentication servces.
  //UserCredential userCredent = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

  //let us now fetch the created user id:
  

  //let us use the id to add to its collections:
  DocumentReference userRef = FirebaseFirestore.instance.collection('students').doc(studentId.toString());
  
  //let us fill in the fields:
  await userRef.set({
    'id': studentId,
    'name': name,
    'pin': pin,
    'receipts': null,
    'status': financialStatus,
    'Daily Limit': (financialStatus == 'MCF') ? 90:70,
    'Today\'s balance': (financialStatus == 'MCF') ? 90:70,
    'accountActive': true, 
    'accountBalance': (financialStatus == 'MCF') ? 13000:10000,



  });

  //for an inner collection, we need to create an inner path from previous address:
  
  //adding a document in that collection
  //collectionreference.doc(the id).set(map); 
  //if theree is no already set map to use, do as follows:
 

  //continue to pick another document, and adding any collection if needed.

  

}
//end of creating a student






//fetch student's data
Future<bool> fetchUserData(String userId, UserProvider userProvider) async {

  //fetching current user document from database
  DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('students').doc(userId).get();

  //condition to run if user exists
  if (userSnapshot.exists){

    //putting all non-list type data fields of user class.
    String name = userSnapshot['Name'];
    int id = userSnapshot['id'], pin = userSnapshot['pin'];
    bool accountStatus = userSnapshot['accountActive'];
    
    //getting list data fields
    List<Receipt> receipts = [];
    if(userSnapshot['receipts'].isEmpty){

      for(var receipt in userSnapshot['receipts']){
        List<Food> foods = [];
        for(var food in receipt['foods']){
          Food meal = Food(price: food['unitPrice'], name: food['foodName'], quantity: food['quantity']);
          foods.add(meal);
        }
        Receipt thisReceipt = Receipt(foods: foods, caf: receipt['cafeteriaName'], studentName: receipt['studentName'], studentId: receipt['studentId'], isActive: receipt['isActive'], password: receipt['password']);
        receipts.add(thisReceipt);
      }

    }
    //provided receipt list is empty:

    User user = User(id: id,name: name,pin: pin,accountStatus: accountStatus,receiptList: receipts,status: userSnapshot['status'],data: userSnapshot.data() as Map<String,dynamic>);
    userProvider.setCurrentUser(user);
    return true;
}
  
  else{

    return false;
    
  }
}
//end of method for fetching user data


//fetching cafeteria data:
Future<bool> fetchCafData(String userId, CafProvider cafProvider) async {

  
  DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('cafeteria').doc(userId).get();

  if (userSnapshot.exists){

    Caf user = Caf(id: userId, data: userSnapshot.data() as Map<String,dynamic>);
    cafProvider.setCurrentUser(user);
    return true;

  } 
  else{

    return false;
    
  }
}
//end of method for fetching data of cafeterai.


//creating the food class
class Food{

  //data field
  final double price;
  final String name;
  int? quantity = 0;
  double? netCost;
  bool isReady = true;

  //constructor
  Food({required this.price,required this.name, this.quantity,this.netCost});

  //methods
  void addToQuantity(){
    quantity =(quantity != null)?quantity! + 1:1;
  }

  void reduceQuantity(){
    if ((quantity != null) && quantity! > 0){
      quantity = quantity! -1;
    }
  }

  String getName(){
    return name;
  }

  double getPrice(){
    return price;
  }

  int getQuantity(){
    return (quantity != null)?quantity!:0;
  }

  double getNetCost(){
    netCost = (quantity != null)? quantity! * price:0;
    return netCost!;
  }

  void changeReadyState(){
    isReady = isReady ? false : true;
  }

}
//end of food class.


//start of the receipt class:
class Receipt{

  //data field
  List<Food> foods;
  String? password;
  double totalCost = 0;
  String caf;
  String studentName;
  int studentId;
  bool isActive;

  //constructor
  Receipt({required this.foods,required this.caf, required this.studentName, required this.studentId, required this.isActive,this.password});

  //methods
  void generatePassword(){
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    password = String.fromCharCodes(Iterable.generate(5,(_) => chars.codeUnitAt(rand.nextInt(chars.length))));
  }

  String getPassword(){
    return password!;
  }

  double getTotalCost(){
    for (Food food in foods){
      totalCost += food.getNetCost();
    }
    return totalCost;
  }

  String getStudentName(){
    return studentName;
  }

  int getStudentId(){
    return studentId;
  }

  String getCafName(){
    return caf;
  }

}
//end of receipt class