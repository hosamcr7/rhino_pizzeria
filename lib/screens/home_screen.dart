import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rhino_pizzeria/helpers/backend.dart';
import 'package:rhino_pizzeria/screens/add_product_screen.dart';
import 'package:rhino_pizzeria/screens/login_screen.dart';
import 'package:rhino_pizzeria/screens/maps_screen.dart';

import '../constants.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final _backend =context.read<Backend>();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children:  const [
                      SizedBox(
                        height: 50, width: 50,
                        child: Icon(Icons.menu),
                      ),
                      Text("Rhino Pizzeria",style: TextStyle(
                        fontSize: 22, ), ),
                    ],
                  ),

                  SizedBox(
                    height: 40, width: 40,
                    child: GestureDetector(onTap: ()=> signOut(_backend), child: buildUserLogo(_backend)),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Align(alignment: Alignment.centerLeft,
                        child: buildUserName(_backend)),
                    const SizedBox(height: 10,),
                    const  Text('Welcome back again!',
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              ListTile(
                tileColor: Theme.of(context).primaryColorDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onTap:() => Navigator.push(context, MaterialPageRoute(builder: (context) => const MapsScreen(),)),
                title: const Text('Update truck location',
                  style: TextStyle(
                    color: Colors.white,
                      fontSize: 17, fontWeight: FontWeight.w500),),
                leading: const Icon(Icons.location_on,color:  Colors.white,),
                trailing: const Icon(Icons.arrow_forward,color: Colors.white,),
              ),
              const SizedBox(height: 20,),

                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const   Text('Menu', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
                  SizedBox(width: 80, child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: const [
                      Text('Top',),
                      Text('New',),
                    ],
                  ),),
                ],),
                const SizedBox(height: 20,),
                Expanded(flex: 3, child: context.read<Backend>().getProducts(),),
            ],
          ),
        ),




        floatingActionButton: FloatingActionButton.extended(
            label: const Text("Add product"),
            onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AddProductScreen(),));
        },icon: const Icon(Icons.add)  ),

      ),
    );
  }

  Text buildUserName(Backend _backend) {


    String _name="there";
    final _user=_backend.userAuthData;
    if(_user!=null   && _user.displayName!=null){
       _name=_user.displayName!;
    }
    return Text( 'Hi ' + _name, style:  TextStyle(fontSize: 27,overflow: TextOverflow.clip,
        fontWeight: FontWeight.w900, letterSpacing: 1, color: Theme.of(context).primaryColor),);

  }

  CircleAvatar buildUserLogo(Backend _backend) {
    final _user=_backend.userAuthData;
    if(_user!=null   && _user.photoURL!=null){
      return  CircleAvatar(child: const Icon(Icons.person), foregroundImage: NetworkImage(_user.photoURL!,),);
    }
    else{
      return  const CircleAvatar(child: Icon(Icons.person),);
    }
  }

  void signOut(Backend _backend)async{
    await _backend.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
  }

}




