import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/add_img_data/update_data.dart';
import 'package:flutter/material.dart';

import 'add_data.dart';
class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {

  addNewCourse(){
    showModalBottomSheet(context: context, builder: (context) => AddData(),);
  }

  final Stream<QuerySnapshot> _courseStream = FirebaseFirestore.instance.collection('courses').snapshots();
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Data"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        addNewCourse();
      },child: Icon(Icons.add),),
      body: StreamBuilder(
        stream: _courseStream,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Text("Loading");
          }
          if(snapshot.data!.docs.isEmpty){
            return Text("Empty");
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document){
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(11.0),
              child: Card(
                elevation: 5,
                child: Column(
                  children: [
                    SizedBox(height: 11,),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Course name: ${data['course_name']}",style: TextStyle(fontSize: 18),),
                                Text("Course price: ${data['course_fee']}",style: TextStyle(fontSize: 18)),
                              ],
                            ),

                          PopupMenuButton(
                            onSelected: (value) {
                              currentIndex = value;
                            },
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                    onTap: () {
                                      deleteItem(document.id);
                                      print("Delete clicked");
                                    },
                                    value: "option",child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Delete"),
                                    Icon(Icons.delete)
                                  ],
                                )),
                                PopupMenuItem(
                                    onTap: () {},
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("feedback"),
                                        Icon(Icons.update)
                                      ],
                                    )),
                              ];
                            },),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12,),

                    Stack(
                      children: [
                        Image.network("${data['img']}"),
                        Positioned(
                          right: 0,
                          child: IconButton(onPressed: (){
                            updateItem(document.id,data['course_name'],data['course_fee'],data['img']);
                          }, icon: Icon(Icons.edit,color: Colors.white,)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }).toList(),
          );
        },
      )
    );
  }

  deleteItem(selectedDocuments){
    return FirebaseFirestore.instance.collection('courses')
        .doc(selectedDocuments).delete()
        .then((value) => print("Data is deleted"))
        .catchError((error)=>print(error));
  }

  updateItem(documentId, courseName, courseFee, courseImg) {
    showModalBottomSheet(context: context, builder: (context) => UpdateData(documentId: documentId, courseName: courseName, courseFee: courseFee, courseImg: courseImg),);
  }
}
