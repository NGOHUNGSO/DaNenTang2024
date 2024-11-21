import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String type;
  const RegisterScreen({Key? key, required this.type}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final taxIdController = TextEditingController();
  final companyNameController = TextEditingController();
  final representativeNameController = TextEditingController();
  final addressController = TextEditingController();
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref(); // Realtime Database reference

  int step = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(step == 0
            ? "${widget.type} - Nhập thông tin doanh nghiệp"
            : "${widget.type} - Tạo mật khẩu"),
      ),
      body: step == 0 ? _buildCompanyInfoStep() : _buildPasswordStep(),
    );
  }

  Widget _buildCompanyInfoStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            "Đăng ký doanh nghiệp\nVui lòng nhập thông tin doanh nghiệp",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          TextField(
            controller: taxIdController,
            decoration: InputDecoration(
              labelText: "Mã số thuế",
              hintText: "Nhập mã số thuế",
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: companyNameController,
            decoration: InputDecoration(
              labelText: "Tên công ty",
              hintText: "Nhập tên công ty",
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: representativeNameController,
            decoration: InputDecoration(
              labelText: "Người đại diện",
              hintText: "Nhập tên người đại diện",
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: "Địa chỉ trụ sở",
              hintText: "Nhập địa chỉ trụ sở",
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Gmail",
              hintText: "example@gmail.com",
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              if (_validateCompanyInfo()) {
                setState(() {
                  step = 1;
                });
              }
            },
            child: Text("TIẾP TỤC"),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Tạo mật khẩu cho tài khoản doanh nghiệp của bạn",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Mật khẩu mới",
              suffixIcon: Icon(Icons.visibility),
            ),
            obscureText: true,
          ),
          SizedBox(height: 16),
          TextField(
            controller: confirmPasswordController,
            decoration: InputDecoration(
              labelText: "Nhập lại mật khẩu",
              suffixIcon: Icon(Icons.visibility),
            ),
            obscureText: true,
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              final password = passwordController.text.trim();
              final confirmPassword = confirmPasswordController.text.trim();
              if (password.isEmpty || confirmPassword.isEmpty) {
                _showErrorDialog("Vui lòng nhập đầy đủ mật khẩu");
              } else if (password != confirmPassword) {
                _showErrorDialog("Mật khẩu không khớp");
              } else {
                await _saveToDatabase();
                _showSuccessDialog("Đăng ký thành công!");
              }
            },
            child: Text("HOÀN THÀNH"),
          ),
        ],
      ),
    );
  }

  bool _validateCompanyInfo() {
    if (taxIdController.text.isEmpty) {
      _showErrorDialog("Mã số thuế không được để trống");
      return false;
    }
    if (companyNameController.text.isEmpty) {
      _showErrorDialog("Tên công ty không được để trống");
      return false;
    }
    if (representativeNameController.text.isEmpty) {
      _showErrorDialog("Tên người đại diện không được để trống");
      return false;
    }
    if (addressController.text.isEmpty) {
      _showErrorDialog("Địa chỉ không được để trống");
      return false;
    }
    if (emailController.text.isEmpty) {
      _showErrorDialog("Email không được để trống");
      return false;
    }
    return true;
  }

  Future<void> _saveToDatabase() async {
    try {
      await databaseRef.child("companies").push().set({
        "MaThue": taxIdController.text.trim(),
        "TenCty": companyNameController.text.trim(),
        "TenDaiDien": representativeNameController.text.trim(),
        "DCTruSo": addressController.text.trim(),
        "Gmail": emailController.text.trim(),
        "MatKhau": passwordController.text.trim(), // Không bảo mật, cần mã hóa
        "timestamp": DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _showErrorDialog("Lỗi khi lưu dữ liệu: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Đóng"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Thành công"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              ); // Chuyển sang màn hình đăng nhập
            },
            child: Text("Đóng"),
          ),
        ],
      ),
    );
  }
}
