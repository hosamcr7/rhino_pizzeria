


import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width:  double.maxFinite,
      color: Colors.grey.withOpacity(0.3),
      child: Center(
        child: SizedBox(
          height: 200,
          width: 300,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 40,),
                Text("Please Wait",style: TextStyle(fontSize: 20,letterSpacing: 1, fontWeight: FontWeight.bold,),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}