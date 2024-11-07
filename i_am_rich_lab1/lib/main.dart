import 'package:flutter/material.dart';


void main(){
  runApp(const IamRich());
}

class IamRich extends StatelessWidget{
  const IamRich({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.cyan[300],
          appBar: AppBar(
            backgroundColor: Colors.cyan[700],
            title: const Text("Tôi là Người Giàu...Tình cảm",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Image(
                  image: AssetImage("images/GiauTinhCam.jpg"),
                  width: 300,
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}