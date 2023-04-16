import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('blog').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return Text("Something went wrong");
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Text("Loading");
        }
        if(snapshot.data!.docs.isEmpty){
          return Text("data empty");
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Container(
              height: 400,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network("${data['img']}"),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(data['title']),
                          Text(data['des']),
                          ElevatedButton(onPressed: (){
                            customDialog(data['img'],data['title'],data['des']);
                          }, child: Text("Show Details"))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  customDialog(String img,String title, String des){
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            height: 300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(child: Image.network(img),borderRadius: BorderRadius.circular(21),),
                  SizedBox(height: 10,),
                  Text(title,style: TextStyle(fontSize: 18),),
                  SizedBox(height: 10,),
                  Text(des,style: TextStyle(fontSize: 18),)
                ],
              ),
            ),
          ),
        );
      },

    );
  }
}
