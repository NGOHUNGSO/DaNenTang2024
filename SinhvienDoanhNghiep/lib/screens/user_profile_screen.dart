import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login_screen.dart';
import 'user_profile_edit_screen.dart';
import 'cv_list_screen.dart'; // Import file danh sách CV
import 'company_list_screen.dart'; // Import file danh sách doanh nghiệp

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  String name = '-';
  String email = '-';
  String avatarUrl = 'assets/default_avatar.png';
  String studentId = '-';
  String className = '-';
  String phone = '-';
  String address = '-';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final snapshot = await databaseRef.child('sinhvien/khoa/2021/lop/21SE3/${widget.userId}').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          name = data['HoTen'] ?? '-';
          email = data['Gmail'] ?? '-';
          avatarUrl = data['Avata'] ?? 'assets/default_avatar.png';
          studentId = data['MaSV'] ?? '-';
          className = data['Lop'] ?? '-';
          phone = data['SDT']?.toString() ?? '-';
          address = data['ThuongTru'] ?? '-';
        });
      }
    } catch (e) {
      print("Error loading user info: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cá nhân"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: avatarUrl.startsWith('http')
                        ? NetworkImage(avatarUrl)
                        : AssetImage(avatarUrl) as ImageProvider,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    email,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, "Trang chủ", () {}),
            _buildDrawerItem(Icons.person, "Quản lý cá nhân", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfileEditScreen(userId: widget.userId),
                ),
              );
            }),
            _buildDrawerItem(Icons.list, "Danh sách CV", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CvListScreen(),
                ),
              );
            }),
            _buildDrawerItem(Icons.business, "Danh sách DN", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanyListScreen(),
                ),
              );
            }),
            _buildDrawerItem(Icons.logout, "Đăng xuất", () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar and Name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: avatarUrl.startsWith('http')
                        ? NetworkImage(avatarUrl)
                        : AssetImage(avatarUrl) as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$studentId - $className",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Personal Info
            _buildSectionTitle("Thông tin cá nhân"),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow("Họ & Tên", name),
                    _buildInfoRow("Email", email),
                    _buildInfoRow("Mã SV", studentId),
                    _buildInfoRow("Lớp", className),
                    _buildInfoRow("SDT", phone),
                    _buildInfoRow("Địa chỉ", address),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // CV Details
            _buildSectionTitle("Chi tiết CV"),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CvDetailScreen(userId: widget.userId),
                  ),
                );
              },
              child: _buildImageCard(
                "https://via.placeholder.com/300x150", // Placeholder image link
                "DANI MARTINEZ",
                "Real Estate Sales Manager",
              ),
            ),
            const SizedBox(height: 16),
            // Products Section
            _buildSectionTitle("Sản phẩm"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(4, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(userId: widget.userId),
                        ),
                      );
                    },
                    child: _buildProductCard("https://via.placeholder.com/100"),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            // Experience Section
            _buildSectionTitle("Kinh nghiệm"),
            _buildExperienceCard(
              "2016 - 2019",
              "Marketing Manager",
              "Managed company's marketing projects and campaigns.",
            ),
            _buildExperienceCard(
              "2019 - 2023",
              "Software Developer",
              "Developed and maintained mobile applications.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String imageUrl, String title, String subtitle) {
    return Card(
      child: Column(
        children: [
          Image.network(imageUrl, width: double.infinity, height: 150, fit: BoxFit.cover),
          ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Card(
        child: Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildExperienceCard(String year, String title, String description) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(child: Text(year.split('-').first)),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }
}

class CvDetailScreen extends StatelessWidget {
  final String userId;

  const CvDetailScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết CV"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage("https://via.placeholder.com/150"),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "NGÔ HÙNG SỞ",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "SINH VIÊN NĂM 2",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Hồ sơ cá nhân"),
            const SizedBox(height: 8),
            _buildDetailCard("Giới thiệu về bản thân", "Tôi là kỹ thuật viên phần mềm chuyên về..."),
            const SizedBox(height: 16),
            _buildSectionTitle("Kinh nghiệm tích lũy"),
            _buildDetailCard("Thực tập tại FPT Đà Nẵng", "Năm 2"),
            const SizedBox(height: 16),
            _buildSectionTitle("Kỹ năng"),
            _buildDetailCard("Front-End", "React.js, Angular, Vue.js"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle print logic
                  },
                  child: const Text("in CV"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CvEditScreen(userId: userId),
                      ),
                    );
                  },
                  child: const Text("Chỉnh sửa"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDetailCard(String title, String description) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}

class CvEditScreen extends StatelessWidget {
  final String userId;

  const CvEditScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa thông tin CV"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Hồ sơ cá nhân"),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: "Giới thiệu về bản thân"),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle("Kinh nghiệm tích lũy"),
            TextField(
              decoration: const InputDecoration(labelText: "Kinh nghiệm"),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle("Kỹ năng"),
            TextField(
              decoration: const InputDecoration(labelText: "Kỹ năng"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle save logic here
              },
              child: const Text("Lưu"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String userId;

  const ProductDetailScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết sản phẩm"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Tên sản phẩm"),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: "Tên sản phẩm"),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle("Mô tả"),
            TextField(
              decoration: const InputDecoration(labelText: "Mô tả"),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle("Thêm hình ảnh"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Handle image upload logic here
              },
              child: const Text("Tải lên"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle save logic here
              },
              child: const Text("Lưu"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}





class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng nhập"),
      ),
      body: const Center(
        child: Text("Trang đăng nhập"),
      ),
    );
  }
}
