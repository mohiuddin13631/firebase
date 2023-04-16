import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("Sign in Successfull",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
