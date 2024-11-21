import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'company_profile_screen.dart'; // Import màn hình CompanyProfileScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _userType = "doanhnghiep"; // Biến để lưu loại người dùng (doanh nghiệp)

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Truy xuất dữ liệu từ Firebase dựa vào loại tài khoản
      String path = 'companies';
      final snapshot = await _databaseRef.child(path).get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        bool isAuthenticated = false;
        String companyId = ""; // Biến lưu ID công ty

        // Kiểm tra thông tin đăng nhập
        data.forEach((key, value) {
          if (value['Gmail'] == email && value['MatKhau'] == password) {
            isAuthenticated = true;
            companyId = key; // Lưu ID công ty
          }
        });

        if (isAuthenticated) {
          // Đăng nhập thành công -> Chuyển đến CompanyProfileScreen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đăng nhập thành công!")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CompanyProfileScreen(companyId: companyId),
            ),
          );
        } else {
          // Sai thông tin đăng nhập
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sai Gmail hoặc mật khẩu!")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Không tìm thấy thông tin!")),
        );
      }
    } catch (e) {
      print("Lỗi: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xảy ra lỗi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng nhập"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Gmail"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Mật khẩu"),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Đăng nhập"),
            ),
          ],
        ),
      ),
    );
  }
}
