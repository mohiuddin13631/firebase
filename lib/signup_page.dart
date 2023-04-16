import 'package:firebase/helper/myhelper.dart';
import 'package:firebase/signin_page.dart';
import 'package:flutter/material.dart';
class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Sign up page"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
               hintText: "Enter email",
               labelText: "Enter Email",
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(16)
               )
              ),
            ),
            SizedBox(height: 11,),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: "Enter Password",
                  labelText: "Enter Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)
                  )
              ),
            ),
            SizedBox(height: 11,),
            ElevatedButton(onPressed: (){
              var obj = MyHelper().singUp(emailController.text, passwordController.text, context);
            }, child: Text("SignUp")),
            SizedBox(height: 11,),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage(),));
            }, child: Text("Already register? SignIn"))
          ],
        ),
      ),
    );
  }
}
