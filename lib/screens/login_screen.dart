import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rhino_pizzeria/helpers/backend.dart';
import 'package:rhino_pizzeria/helpers/functions.dart';
import 'package:provider/provider.dart';
import 'package:rhino_pizzeria/screens/home_screen.dart';
import 'package:rhino_pizzeria/widgets/loading_widget.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>  with SingleTickerProviderStateMixin{

  bool loading = false;
  void onTap()async{

    setState(() {loading=true;});
  final result= await loginWithGoogle();
  if(result!=null) {
    context.read<Backend>().googleSignInData=result.user;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:  Text("Log-In successfully")));

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const HomeScreen(),));
  }else{
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong email or password")));
  }
    setState(() {loading=false;});

  }


  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    _controller.forward(from: 0.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [
                FadeTransition(
                  opacity: _animation,
                  child: SvgPicture.asset(
              "assets/login.svg",
                  height: MediaQuery.of(context).size.longestSide/1.6,
                  ),
                ),

                 Expanded(
                   child: ClipRRect(
                     borderRadius:const BorderRadius.only(topRight:  Radius.circular(30),topLeft: Radius.circular(30)),
                     child: Container(
                       width: double.maxFinite,
                       color: Theme.of(context).primaryColorDark,
                       child: Padding(
                         padding: const EdgeInsets.all(20.0),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Sign In",style: TextStyle(fontSize: 30,letterSpacing: 1, fontWeight: FontWeight.bold,color: Colors.white),),
                              Center(child: Text("Welcome to Rhino Pizzeria",style: TextStyle(fontSize: 22,letterSpacing: 1, fontWeight: FontWeight.bold,color: Colors.grey.shade200),)),

                             Center(
                               child: SizedBox (
                                 width: 300,
                                 height: 70,
                                 child: FloatingActionButton.extended(
                                   elevation: 0,
                                   onPressed:onTap,label:const Text("Continue With Google"),icon:SvgPicture.asset(
                                   "assets/google.svg",
                                   height: 50,
                                 ),),
                               ),
                             )
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),

            ],
          ),
          Visibility(
              visible:loading ,
              child: const LoadingWidget())

        ],
      ),
    );
  }
}


