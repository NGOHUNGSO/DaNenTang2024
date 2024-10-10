import 'package:flutter/material.dart';
import 'dart:math';

// Creates a Material App
void main() => runApp(
      MaterialApp(
        home: BallPage(),
      ),
    );

// Creates a Scaffold with
// appbar using Stateless widget
class BallPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: Text(
          'Magic Ball',
          style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              letterSpacing: 2.5,
              fontFamily: 'Source Sans Pro'),
        ),
      ),
      body: Ball(),
    );
  }
}

// Creates a Stateful widget
class Ball extends StatefulWidget {
  const Ball({Key? key}) : super(key: key);

  @override
  _BallState createState() => _BallState();
}

class _BallState extends State<Ball> {
  int ballNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          setState(() {
            // Random.nextInt(n) returns a random integer from 0 to n-1
            ballNumber = Random().nextInt(5) + 1;
          });
        },
        // Adding images
        child: Image.asset('images/ball$ballNumber.png'),
      ),
    );
  }
}
