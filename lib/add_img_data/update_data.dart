import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class UpdateData extends StatefulWidget {
  String documentId;
  String courseName;
  String courseFee;
  String courseImg;
  UpdateData({required this.documentId,required this.courseName,required this.courseFee,required this.courseImg});


  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {

  String defaultCourseName(){
    return widget.courseName;
  }

  TextEditingController updateNameController =  TextEditingController();
  TextEditingController updateFeeController = TextEditingController();
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
              controller: updateNameController,
              decoration: InputDecoration(
                hintText: widget.courseName,
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
              keyboardType: TextInputType.number,
              controller: updateFeeController,
              decoration: InputDecoration(
                hintText: widget.courseFee,
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
            Container(
              child: Stack(
                children: [
                  courseImage == null?
                  Image.network(widget.courseImg):
                  Image.file(File(courseImage!.path)),
                  Positioned(
                    right: 0,
                    child: IconButton(onPressed: (){
                      showModalBottomSheet(context: context, builder: (context) {
                        return showBottom(context);
                      },);
                    }, icon: Icon(Icons.edit,color: Colors.white,)),
                  )
                ],
              )
            ),//todo
            ElevatedButton(onPressed: (){updateItem(widget.documentId);}, child: Text("Update"))
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

  updateItem(selectedDocument)async{
    //todo: image upload into storage and get download url

    if(courseImage == null){
      CollectionReference course = FirebaseFirestore.instance.collection('courses');
      course.doc(selectedDocument).update({
        'course_name' : updateNameController.text,
        'course_fee' : updateFeeController.text,
        'img' : widget.courseImg
      });
    }
    else{
      File imgFile = File(courseImage!.path);
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      UploadTask uploadTask = firebaseStorage.ref('images').child(courseImage!.name).putFile(imgFile);//created folder then image name then keep image file
      TaskSnapshot snapshot = await uploadTask;
      var imgUrl = await snapshot.ref.getDownloadURL();

      CollectionReference course = FirebaseFirestore.instance.collection('courses');
      course.doc(selectedDocument).update({
        'course_name' : updateNameController.text,
        'course_fee' : updateFeeController.text,
        'img' : imgUrl
      });
    }
    Navigator.pop(context);
  }

}
