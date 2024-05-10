

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//Student class

class User {

//data fields
  String id, name = '';
  Map<String,dynamic> data;
  String selectedCafId = '';
  List<Food> foodsInSelection = [];
  List<Receipt> receiptList = [];
  int pin =0;
  
  dynamic operator [](String key) => data[key];

//end of data field


//constructor
  User({required this.id,required this.data});

  //update
  void updateCafId(String code){
    selectedCafId = code;
  }

  //get cafeteria id
  bool changedPin(int oldPin, int newPin){

    pin = (pin == oldPin) ? newPin: oldPin;

    return (newPin == pin) ? true:false;
  }

  //add receipt to the list
  void addReceipt(Receipt receipt){
    receiptList.add(receipt);
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


Future<void> createStudent(String name,String email, String password) async{

  //creating user with email and password using firebase authentication servces.
  UserCredential userCredent = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

  //let us now fetch the created user id:
  String uid = userCredent.user!.uid;

  //let us use the id to add to its collections:
  DocumentReference userRef = FirebaseFirestore.instance.collection('students').doc(uid);
  
  //let us fill in the fields:
  await userRef.set({
    'uid': uid,
    'name': name,
    'email': email,
    //...and the rest follows.


  });

  //for an inner collection, we need to create an inner path from previous address:
  CollectionReference receipts = userRef.collection('Receipts');
  //adding a document in that collection
  //collectionreference.doc(the id).set(map); 
  //if theree is no already set map to use, do as follows:
  await receipts.doc('docId').set(
    {
      'name': 'frank'
    }
  );

  //continue to pick another document, and adding any collection if needed.

  

}
//end of creating a student

//fetch student's data
Future<bool> fetchUserData(String userId, UserProvider userProvider) async {

  
  DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('students').doc(userId).get();

  if (userSnapshot.exists){

    User user = User(id: userId, data: userSnapshot.data() as Map<String,dynamic>);
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
  int quantity = 0;
  double netCost = 0;
  bool isReady = true;

  //constructor
  Food({required this.price,required this.name});

  //methods
  void addToQuantity(){
    quantity++;
  }

  void reduceQuantity(){
    if (quantity > 0){
      quantity--;
    }
  }

  String getName(){
    return name;
  }

  double getPrice(){
    return price;
  }

  int getQuantity(){
    return quantity;
  }

  double getNetCost(){
    netCost = quantity * price;
    return netCost;
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
  String password = '';
  double totalCost = 0;
  String caf;
  String studentName;
  int studentId;

  //constructor
  Receipt({required this.foods,required this.caf, required this.studentName, required this.studentId});

  //methods
  void generatePassword(){
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    password = String.fromCharCodes(Iterable.generate(5,(_) => chars.codeUnitAt(rand.nextInt(chars.length))));
  }

  String getPassword(){
    return password;
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