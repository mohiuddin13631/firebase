
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final Stream<QuerySnapshot> _popularStream = FirebaseFirestore.instance.collection('popular_blog').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _popularStream,
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Text("Something went wrong");
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return Text("loading");
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document){
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(11.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      child: Text(data['title'][0]),
                    ),
                    Text(data['title']),
                    Icon(Icons.more_horiz)
                  ],

                ),
                Container(
                  height: 300,
                    width: MediaQuery.of(context).size.width * .8,
                    child: Image.network(data['img']))
              ],
            ),
          );
        }).toList()
        );
      },
    );
  }
}
