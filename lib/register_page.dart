import 'package:firebase/helper/myhelper.dart';
import 'package:firebase/signin_page.dart';
import 'package:flutter/material.dart';
class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();
  TextEditingController agedController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "Enter name",
                  labelText: "Enter name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)
                  )
              ),
            ),
            SizedBox(height: 11,),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                  hintText: "Enter phone number",
                  labelText: "Enter phone number",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)
                  )
              ),
            ),
            SizedBox(height: 11,),
            TextField(
              controller: agedController,
              decoration: InputDecoration(
                  hintText: "Enter age",
                  labelText: "Enter age",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)
                  )
              ),
            ),
            SizedBox(height: 11,),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                  hintText: "Enter address",
                  labelText: "Enter address",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)
                  )
              ),
            ),
            ElevatedButton(onPressed: (){
              // var obj = MyHelper().singUp(emailController.text, passwordController.text, context);
              MyHelper().register(nameController.text, phoneController.text, agedController.text, addressController.text);
            }, child: Text("Register")),
          ],
        ),
      ),
    );
  }
}
