

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class User {
  final String id;
  final Map<String,dynamic> data;

  User({required this.id,required this.data});

  dynamic operator [](String key) => data[key];

}

//creating a cafeteria class
class Caf {
  final String id;
  final Map<String,dynamic> data;

  Caf({required this.id,required this.data});

  dynamic operator [](String key) => data[key];
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

  
  DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('cafeterias').doc(userId).get();

  if (userSnapshot.exists){

    Caf user = Caf(id: userId, data: userSnapshot.data() as Map<String,dynamic>);
    cafProvider.setCurrentUser(user);
    return true;

  } 
  else{

    return false;
    
  }
}