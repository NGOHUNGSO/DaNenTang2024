import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfileEditScreen extends StatefulWidget {
  final String userId;

  const UserProfileEditScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileEditScreenState createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends State<UserProfileEditScreen> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  // Controllers for all fields
  final nameController = TextEditingController();
  final gmailController = TextEditingController();
  final khoaController = TextEditingController();
  final lopController = TextEditingController();
  final maSVController = TextEditingController();
  final matKhauController = TextEditingController();
  final moTaController = TextEditingController();
  final nganhController = TextEditingController();
  final ngaySinhController = TextEditingController();
  final queController = TextEditingController();
  final sdtController = TextEditingController();
  final thanhTichController = TextEditingController();
  final thuongTruController = TextEditingController();
  final tinhTrangController = TextEditingController();
  final truongController = TextEditingController();
  final bangCapController = TextEditingController();
  final chungChiController = TextEditingController();
  final danTocController = TextEditingController();
  final diemGPAController = TextEditingController();
  final kinhNghiemController = TextEditingController();
  final gioiTinhController = TextEditingController();

  File? avatarFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final snapshot = await databaseRef.child('sinhvien/khoa/2021/lop/21SE3/${widget.userId}').get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        nameController.text = data['HoTen'] ?? '';
        gmailController.text = data['Gmail'] ?? '';
        khoaController.text = data['Khoa'] ?? '';
        lopController.text = data['Lop'] ?? '';
        maSVController.text = data['MaSV'] ?? '';
        matKhauController.text = data['MatKhau'] ?? '';
        moTaController.text = data['MoTaCaNhan'] ?? '';
        nganhController.text = data['Nganh'] ?? '';
        ngaySinhController.text = data['NgaySinh'] ?? '';
        queController.text = data['Que'] ?? '';
        sdtController.text = data['SDT']?.toString() ?? '';
        thanhTichController.text = data['ThanhTich'] ?? '';
        thuongTruController.text = data['ThuongTru'] ?? '';
        tinhTrangController.text = data['TinhTrang'] ?? '';
        truongController.text = data['Truong'] ?? '';
        bangCapController.text = data['BangCap'] ?? '';
        chungChiController.text = data['ChungChi'] ?? '';
        danTocController.text = data['DanToc'] ?? '';
        diemGPAController.text = data['DiemGPA']?.toString() ?? '';
        kinhNghiemController.text = data['KinhNghiem'] ?? '';
        gioiTinhController.text = data['GioiTinh'] ?? '';
      });
    }
  }

  Future<void> _pickAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        avatarFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateUserData() async {
    try {
      final updatedData = {
        'HoTen': nameController.text.trim(),
        'Gmail': gmailController.text.trim(),
        'Khoa': khoaController.text.trim(),
        'Lop': lopController.text.trim(),
        'MaSV': maSVController.text.trim(),
        'MatKhau': matKhauController.text.trim(),
        'MoTaCaNhan': moTaController.text.trim(),
        'Nganh': nganhController.text.trim(),
        'NgaySinh': ngaySinhController.text.trim(),
        'Que': queController.text.trim(),
        'SDT': sdtController.text.trim(),
        'ThanhTich': thanhTichController.text.trim(),
        'ThuongTru': thuongTruController.text.trim(),
        'TinhTrang': tinhTrangController.text.trim(),
        'Truong': truongController.text.trim(),
        'BangCap': bangCapController.text.trim(),
        'ChungChi': chungChiController.text.trim(),
        'DanToc': danTocController.text.trim(),
        'DiemGPA': diemGPAController.text.trim(),
        'KinhNghiem': kinhNghiemController.text.trim(),
        'GioiTinh': gioiTinhController.text.trim(),
      };

      await databaseRef.child('sinhvien/khoa/2021/lop/21SE3/${widget.userId}').update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật thông tin thành công!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xảy ra lỗi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa thông tin cá nhân"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickAvatar,
                child: CircleAvatar(
                  radius: 50,
                  child: avatarFile != null
                      ? ClipOval(
                    child: Image.file(
                      avatarFile!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.person, size: 50),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField("Họ & Tên", nameController),
              _buildTextField("Gmail", gmailController),
              _buildTextField("Khoa", khoaController),
              _buildTextField("Lớp", lopController),
              _buildTextField("Mã SV", maSVController),
              _buildTextField("Mật khẩu", matKhauController),
              _buildTextField("Mô tả cá nhân", moTaController),
              _buildTextField("Ngành", nganhController),
              _buildTextField("Ngày sinh", ngaySinhController),
              _buildTextField("Quê quán", queController),
              _buildTextField("Số điện thoại", sdtController),
              _buildTextField("Thành tích", thanhTichController),
              _buildTextField("Thường trú", thuongTruController),
              _buildTextField("Tình trạng", tinhTrangController),
              _buildTextField("Trường", truongController),
              _buildTextField("Bằng cấp", bangCapController),
              _buildTextField("Chứng chỉ", chungChiController),
              _buildTextField("Dân tộc", danTocController),
              _buildTextField("GPA", diemGPAController),
              _buildTextField("Kinh nghiệm", kinhNghiemController),
              _buildTextField("Giới tính", gioiTinhController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateUserData,
                child: const Text("Lưu"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
