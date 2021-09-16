import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_pizzeria/screens/loading_screen.dart';

import 'helpers/backend.dart';

void main() {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Backend()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(

          primarySwatch: Colors.deepOrange,
          floatingActionButtonTheme:const FloatingActionButtonThemeData(backgroundColor: Colors.black)
        ),
        home:  const LoadingScreen(),
      ),
    );
  }
}

