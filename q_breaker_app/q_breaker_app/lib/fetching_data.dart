

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class User {
  final String id;
  final Map<String,dynamic> data;

  User({required this.id,required this.data});

  dynamic operator [](String key) => data[key];

}


//Provider class: holds the engredients from the data (fridge)
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