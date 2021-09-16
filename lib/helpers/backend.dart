


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'functions.dart';


class Backend extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _userAuthData;
  User? get userAuthData => _userAuthData;
  set googleSignInData(User? value) {
    _userAuthData = value;
    notifyListeners();
  }


  Future signOut()async{
    await FirebaseAuth.instance.signOut();
    _userAuthData=null;
    notifyListeners();
  }


  Widget getProducts(){
   return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('products').snapshots() ,
        builder: (context, snapshot){
          List<Widget> list=[];
          if (snapshot.hasData && snapshot.data!=null){
            final  results=snapshot.data!.docs;
            for(var i in results){
              list.add(mapProductCardFromFirestore(i.data())) ;
            }
            return list.isEmpty?  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.error,size: 35,),
                Center(child: Text("Check your connection and try again",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 1,))),
              ],
            )
                :ListView(children: list,);
          }
          else {
            return Center(
              child: SizedBox(height: 100,child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  CircularProgressIndicator(),
                  Text("loading...",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 1)),
                ],
              )),
            );
          }
        });
  }

}