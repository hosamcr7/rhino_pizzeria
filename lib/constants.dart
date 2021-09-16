
import 'package:flutter/material.dart';


enum Types {
  requiredOne,
  requiredMulti,
  optionalMulti,
}

const Map<String, Types> mapTypes = {
  "Types.requiredOne": Types.requiredOne,
  "Types.requiredMulti": Types.requiredMulti,
  "Types.optionalMulti": Types.optionalMulti,

};



const KTextFieldDecoration=InputDecoration(

  filled: true,
  labelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,letterSpacing: 2),
  hintText: '',
  contentPadding:

  EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide( color: Colors.transparent, width: 0.0),
    borderRadius:  BorderRadius.all(Radius.circular(20.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide( width: 2.1),
    borderRadius:  BorderRadius.all(Radius.circular(20.0)),
  ),
);