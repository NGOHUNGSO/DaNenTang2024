import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage('images/Oh.jpg'),
                ),
                Text('Apo-ST',
                  style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico'
                  ),
                ),
                Text('Đa Nền Tảng',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      letterSpacing: 2.5,
                      fontFamily: 'Source Sans Pro'
                  ),
                ),
                Card(
                  elevation: 10.0,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 45.0),
                  child: ListTile(
                      leading: Icon(
                        Icons.phone_android,
                        color: Colors.black,
                      ),
                      title: Text(
                        '0369402764',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Source Sans Pro',
                            color: Colors.black
                        ),
                      )
                  ),
                ),
                Card(
                    elevation: 10.0,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 45.0),
                    child: ListTile(
                      leading: Icon(
                          Icons.email,
                          color: Colors.black
                      ),
                      title : Text(
                        'ApoST@vku.udn.vn',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Source Sans Pro',
                            color: Colors.black
                        ),
                      ),
                    )
                )
              ],
            )
        ),
      ),
    );
  }
}
