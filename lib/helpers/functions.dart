import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rhino_pizzeria/constants.dart';
import 'package:rhino_pizzeria/widgets/modifier_data_card.dart';
import 'package:rhino_pizzeria/widgets/product_card.dart';
import 'helper_classes.dart';

Future<UserCredential?> loginWithGoogle() async {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  try {
  final GoogleSignInAccount? googleUser=  await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  final result= await FirebaseAuth.instance.signInWithCredential(credential);
  return result;
  } catch (error) {
    print(error);
    print("\n\n\n\n\n\n\n");
    return null;
  }

}


Future uploadProduct({required ProductHelper product,}) async {

    try{
      FirebaseFirestore _fireStore = FirebaseFirestore.instance;
      Uint8List _fileData=await File(product.imagePath).readAsBytes();
      Reference storageReference = FirebaseStorage.instance.ref().child("images").child(product.imagePath.hashCode.toString());
      UploadTask uploadTask = storageReference.putData( _fileData,);
      await uploadTask.whenComplete(() =>  print('File Uploaded'));
      final    fileURL= await storageReference.getDownloadURL();
      DocumentReference reference =  _fireStore.collection("products").doc();
      await reference.set(
          {
            'link': fileURL,
            'time':FieldValue.serverTimestamp(),
            'name':product.name,
            'description':product.description,
            'modifiers':product.productModifiers.map((e) =>
            {
              "name":e.name,
              "type":e.type.toString(),
              "data":e.modifierData,
            }
            ).toList(),
          }
      );
    }
    catch (e){
      print(e);
    }

}

Future updateTruckLocation(double lat, double lon)async{
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  DocumentReference reference =  _fireStore.collection("locations").doc("truck_location");
  await reference.set({"location": GeoPoint( lat,  lon)});
}


ProductCard mapProductCardFromFirestore(data){

  final name=data["name"];
  final description=data["description"];
  final link=data["link"];
  final List<dynamic> modifiers=data["modifiers"];
  return ProductCard(name: name, description: description, imageUrl: link,
    modifierData: modifiers.map((e) => ModifierDataCard(modifierName: e["name"],modifierChoices:e["data"] , type:mapTypes[e["type"]]!)).toList(),);
}