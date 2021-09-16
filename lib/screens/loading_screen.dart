import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rhino_pizzeria/helpers/backend.dart';
import 'package:rhino_pizzeria/screens/home_screen.dart';
import 'package:rhino_pizzeria/screens/login_screen.dart';
import 'package:provider/provider.dart';



class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {



  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();

      tryLogin();
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error: check your connection and try again",)));
    }
  }


  void tryLogin()async{
    final _oldUser=FirebaseAuth.instance.currentUser;

    if(_oldUser==null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
    }
    else{
      context.read<Backend>().googleSignInData=_oldUser;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Material(
      child:  Center(child: CircularProgressIndicator()),
    );
  }
}
