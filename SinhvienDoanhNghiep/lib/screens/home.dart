import 'package:flutter/material.dart';

import 'login_screen.dart'; // Đảm bảo file login_screen.dart tồn tại.
import 'register_screen.dart';
import 'company_profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Thêm Scaffold Key
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 16.0), // Tạo khoảng cách với mép trên màn hình
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal:
                    16.0), // Tạo padding bên trong AppBar để các thành phần không dính vào nhau
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.black),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showLoginDialog(context);
                                  },
                                  child: Text(
                                    "ĐĂNG NHẬP/\nĐĂNG KÝ?",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                                width: 8), // Khoảng cách giữa văn bản và avatar
                            GestureDetector(
                              onTap: () {
                                _showLoginDialog(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2.0), // Padding để avatar có không gian và giữ hình dạng
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: CircleAvatar(
                                  radius:30,
                                  backgroundImage:
                                  AssetImage('assets/user.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Nội dung của trang sau AppBar
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildCard(
                          context,
                          "Xin chào Chúng tôi là ...",
                          "Kết nối sinh viên tới doanh nghiệp",
                          Colors.red,
                          'assets/sv.png',
                              () {},
                          false,
                        ),
                        const SizedBox(height: 16),
                        _buildCard(
                          context,
                          "Nếu bạn là Sinh viên ...",
                          "Nhấn vào đây",
                          Colors.yellow,
                          'assets/csv.png',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          true,
                        ),
                        const SizedBox(height: 16),
                        _buildCard(
                          context,
                          "Nếu bạn là Doanh Nghiệp ...",
                          "Nhấn vào đây",
                          Colors.blue,
                          'assets/dn.png',
                              () {
                            _showLoginDialog(context);
                          },
                          false,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Liên hệ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Page",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "SinhVienSV",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Website",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "www.sinhviencv.com",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hỗ trợ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Về chúng tôi",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Thỏa thuận người dùng",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Chính sách bảo mật",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Điều khoản dịch vụ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: const Center(
                child: Text(
                  "Đăng nhập/Đăng ký?",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            _buildDrawerItem(Icons.home, "Trang chủ", context),
            _buildDrawerItem(Icons.info, "Giới thiệu", context),
            _buildDrawerItem(Icons.event, "Tin tức - Sự kiện", context),
            _buildDrawerItem(Icons.list, "Danh sách CV", context),
            _buildDrawerItem(Icons.post_add, "Bài đăng tuyển", context),
            _buildDrawerItem(Icons.business, "Danh sách DN", context),
            _buildDrawerItem(Icons.person, "Quản lý cá nhân", context),
            _buildDrawerItem(Icons.logout, "Đăng xuất", context),
          ],
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
              Center(
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/dn-dk.png',
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              _showStudentDialog(context);
                            },
                            child: const Text(
                              "Đăng ký",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Đăng nhập",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStudentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
              Center(
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // "CỰU SINH VIÊN"
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Đóng dialog hiện tại
                          // Điều hướng đến màn hình đăng ký "Cựu Sinh Viên" (nếu cần, có thể thay đổi logic ở đây)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(), // Chuyển hướng đến LoginScreen
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.yellow,
                              radius: 50,
                              child: Image.asset(
                                'assets/csv.png',
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "CỰU SINH VIÊN",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // "DOANH NGHIỆP"
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Đóng dialog hiện tại
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(type: "Doanh Nghiệp"),
                            ),
                          ); // Chuyển hướng đến màn hình đăng ký doanh nghiệp
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 50,
                              child: Image.asset(
                                'assets/dn.png',
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "DOANH NGHIỆP",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(
      BuildContext context,
      String title,
      String subtitle,
      Color color,
      String imagePath,
      VoidCallback onTap,
      bool isImageRight,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: isImageRight
                ? [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 150, // Điều chỉnh kích thước ảnh to lên
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ]
                : [
              Expanded(
                flex: 1,
                child: Container(
                  height: 150, // Điều chỉnh kích thước ảnh to lên
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
