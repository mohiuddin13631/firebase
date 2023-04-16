
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

class MyHelper{

  Future singUp(email, password, context) async {//todo: sign in
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(credential.user!.uid.isNotEmpty){
        Navigator.push(context,MaterialPageRoute(builder: (context) => SignInPage(),));
      }
      else{
        print("Not valid");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  bool isSignUp = false;
  Future singIn(email, password, context) async { //todo: sign up
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(credential.user!.uid.isNotEmpty){
        isSignUp = true;
        Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage(),));
      }
      else{
        print("Not valid");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future register(name,phone,age,address,[context]) async { //register
    try{
      CollectionReference user = FirebaseFirestore.instance.collection("register");
      user.add(({
        "name" : name,
        "phone" : phone,
        "age" : age,
        "address" : address,
      }));
    }catch(e){
      print(e);
    }
  }
}