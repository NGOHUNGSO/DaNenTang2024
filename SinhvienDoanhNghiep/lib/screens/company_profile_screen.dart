import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CompanyProfileScreen extends StatefulWidget {
  final String companyId; // ID của công ty trong Firebase

  CompanyProfileScreen({required this.companyId});

  @override
  _CompanyProfileScreenState createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<dynamic, dynamic>? companyData;

  @override
  void initState() {
    super.initState();
    _fetchCompanyData(); // Gọi hàm lấy dữ liệu khi khởi tạo
  }

  Future<void> _fetchCompanyData() async {
    try {
      final snapshot = await _databaseRef.child('companies/${widget.companyId}').get();
      if (snapshot.exists) {
        setState(() {
          companyData = snapshot.value as Map<dynamic, dynamic>;
        });
      } else {
        print("Không tìm thấy dữ liệu công ty");
      }
    } catch (e) {
      print("Lỗi khi lấy dữ liệu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(companyData?['TenCty'] ?? 'Loading...'),
      ),
      body: companyData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin cơ bản
            Card(
              color: Colors.blue[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Họ & Tên", companyData?['TenDaiDien']),
                    _buildInfoRow("Tên Cty", companyData?['TenCty']),
                    _buildInfoRow("Mã cty", companyData?['MaThue']),
                    _buildInfoRow("Email", companyData?['Gmail']),
                    _buildInfoRow("SDT", companyData?['SDT'] ?? 'Không có'),
                    _buildInfoRow("Địa chỉ", companyData?['DCTruSo']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Giới thiệu
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  companyData?['GioiThieu'] ??
                      "Không có thông tin giới thiệu.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Hình ảnh bài đăng
            Text(
              "Bài đăng",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPostImages(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value ?? "Không có"),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImages() {
    // Đây là danh sách hình ảnh (cần cập nhật từ Firebase nếu có dữ liệu)
    List<String> postImages = [

    ];

    return Row(
      children: [
        for (var imageUrl in postImages)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
        GestureDetector(
          onTap: () {
            print("Thêm bài đăng mới");
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(Icons.add, size: 40, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
