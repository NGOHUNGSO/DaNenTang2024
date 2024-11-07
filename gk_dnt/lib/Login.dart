import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCY47ysJ5ry4WLB6jaVw59ltgDtYo0vGEg",
        appId: "1:371518812980:android:35c39f0a4d9edd2764ab61",
        messagingSenderId: "371518812980",
        projectId: "gkdnt-2d508"),
  )
      : await Firebase.initializeApp(); // Khởi tạo Firebase

  runApp(Login());
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.green[300]
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref(); // FirebaseDatabase.instance.reference() đã lỗi thời, dùng .ref() mới

  String? cost; // Biến cost để lưu trữ giá trị cost từ Firebase

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập',
          style: TextStyle(fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                  style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _login(context); // Gọi hàm đăng nhập và truyền context
                  }
                },
                child: Text('Login'),
              ),
              if (cost != null) // Hiển thị giá trị cost sau khi đăng nhập thành công
                Text('Cost: $cost'),
            ],
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    String enteredEmail = _emailController.text;
    String enteredPassword = _passwordController.text;

    // Truy vấn Firebase Realtime Database cho email và password
    DatabaseReference emailRef = _databaseRef.child('User/Admin/Email');
    DatabaseReference passRef = _databaseRef.child('User/Admin/Pass');
    DatabaseReference costRef = _databaseRef.child('User/Admin/Cost'); // Truy vấn cost

    DataSnapshot emailSnapshot = await emailRef.get();
    DataSnapshot passSnapshot = await passRef.get();
    DataSnapshot costSnapshot = await costRef.get(); // Lấy giá trị cost từ Firebase

    if (emailSnapshot.exists && passSnapshot.exists) {
      String storedEmail = emailSnapshot.value.toString();
      String storedPass = passSnapshot.value.toString();

      if (enteredEmail == storedEmail && enteredPassword == storedPass) {
        print('Login successful');
        setState(() {
          cost = costSnapshot.value?.toString() ?? 'No cost available'; // Gán giá trị cost sau khi đăng nhập thành công
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful')),
        );

        // Chuyển đến trang chính sau khi đăng nhập thành công
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()), // Đến MainScreen
        );
      } else {
        print('Invalid email or password');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      }
    } else {
      print('Error: No data found in the database');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No data found in the database')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

