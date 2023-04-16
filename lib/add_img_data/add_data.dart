import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class AddData extends StatefulWidget {
  const AddData({Key? key}) : super(key: key);

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {

  TextEditingController courseNameController = TextEditingController();
  TextEditingController coursePriceController = TextEditingController();
  XFile? courseImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(11),
      height: 400,
      color: Colors.green,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: courseNameController,
              decoration: InputDecoration(
                hintText: "Enter course name",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(16)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(16)
                ),
              ),
            ),
            SizedBox(height: 11,),
            TextField(
              controller: coursePriceController,
              decoration: InputDecoration(
                hintText: "Enter course price",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(16)
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(16)
                ),
              ),
            ),
            SizedBox(height: 12,),
            courseImage == null?
            ElevatedButton(onPressed: () {
              showModalBottomSheet(context: context, builder: (context) {
                return showBottom(context);
              },);
            }, child: Text("Choose Image")):
            Image.file(File(courseImage!.path)),
            ElevatedButton(onPressed: (){writeData();}, child: Text("Submit"))
          ],
        ),
      ),
    );
  }

  showBottom(context)
  {
    return Container(
      height: 150,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                imageFromGallery();
                Navigator.pop(context);
              },
              icon: Icon(Icons.photo,size: 40,)
          ),
          SizedBox(width: 20,),
          IconButton(
              onPressed: () {
                imageFromCamera();
                Navigator.pop(context);
              },
              icon: Icon(Icons.camera,size: 40,)
          ),
        ],
      ),
    );
  }
  imageFromGallery()async{
    
    final ImagePicker picker = ImagePicker();
    courseImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {

    });
  }
  imageFromCamera()async{
    final ImagePicker picker = ImagePicker();
    courseImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {

    });
  }

  writeData()async{
    //todo: image upload into storage and get download url
    File imgFile = File(courseImage!.path);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    UploadTask uploadTask = firebaseStorage.ref('images').child(courseImage!.name).putFile(imgFile);//created folder then image name then keep image file
    TaskSnapshot snapshot = await uploadTask;
    var imgUrl = await snapshot.ref.getDownloadURL();

    //todo: keep image url and other data into fire store database as before
    CollectionReference course = FirebaseFirestore.instance.collection('courses'); //created a collection as then name of courses
    course.add(({
      'course_name' : courseNameController.text,
      'course_fee' : coursePriceController.text,
      'img' : imgUrl
    }));
    Navigator.pop(context);
  }

}
