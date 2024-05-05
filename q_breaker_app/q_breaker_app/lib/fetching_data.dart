

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class User {
  final String id;
  final Map<String,dynamic> data;
  String selectedCafId = '';
  List<Food> foodsInSelection = [];

  User({required this.id,required this.data});

  dynamic operator [](String key) => data[key];

  void updateCafId(String code){
    selectedCafId = code;
  }

  String getCafId(){
    return selectedCafId;
  }

}

//creating a cafeteria class
class Caf {
  final String id;
  final Map<String,dynamic> data;
  List<Food> foods = [];

  Caf({required this.id,required this.data});

  dynamic operator [](String key) => data[key];

  void addFood(String name, double price){
    foods.add(Food(price: price, name: name));
  }
}

//this is the cafeteria provider to use in the code.
class CafProvider extends ChangeNotifier{

  Caf? _currentUser;

  Caf? get currentUser => _currentUser;

  void setCurrentUser(Caf user){

    _currentUser = user;
    notifyListeners();

  }

}

//Provider class: holds the engredients from the data (fridge) for students
class UserProvider extends ChangeNotifier{

  User? _currentUser;

  User? get currentUser => _currentUser;

  void setCurrentUser(User user){

    _currentUser = user;
    notifyListeners();

  }

}

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

//creating the food class

class Food{
  final double price;
  final String name;
  int quantity = 0;
  double netCost = 0;
  bool isReady = true;

  Food({required this.price,required this.name});

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
  List<Food> foods;
  String password = '';
  double totalCost = 0;
  String caf;
  String studentName;
  int studentId;

  Receipt({required this.foods,required this.caf, required this.studentName, required this.studentId});

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