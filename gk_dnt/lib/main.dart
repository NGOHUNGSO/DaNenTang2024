import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCY47ysJ5ry4WLB6jaVw59ltgDtYo0vGEg",
      appId: "1:371518812980:android:35c39f0a4d9edd2764ab61",
      messagingSenderId: "371518812980",
      projectId: "gkdnt-2d508",
    ),
  )
      : await Firebase.initializeApp(); // Khởi tạo Firebase

  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý sản phẩm',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green[300],
      ),
      home: ProductManagementScreen(),
    );
  }
}

class ProductManagementScreen extends StatefulWidget {
  @override
  _ProductManagementScreenState createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.reference().child('Product');
  final List<Map<String, dynamic>> _products = [];
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _typeController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _editingProductId;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        List<Map<String, dynamic>> products = [];
        (data as Map<dynamic, dynamic>).forEach((key, value) {
          products.add({
            'id': key,
            'name': value['Name'],
            'price': value['Price'],
            'type': value['Type'],
            'image': value['Image'],
          });
        });
        setState(() {
          _products.clear();
          _products.addAll(products);
        });
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _addProduct() async {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _typeController.text.isNotEmpty &&
        _image != null) {
      try {
        String productId = 'SP${_products.length + 1}';

        // Upload ảnh lên Firebase Storage
        final storageRef =
        FirebaseStorage.instance.ref().child('ProductImages/$productId');
        await storageRef.putFile(_image!);

        // Lấy URL của ảnh sau khi tải lên
        String imageUrl = await storageRef.getDownloadURL();

        // Lưu thông tin sản phẩm vào Realtime Database
        await _dbRef.child(productId).set({
          'Name': _nameController.text,
          'Price': _priceController.text,
          'Type': _typeController.text,
          'Image': imageUrl, // Lưu URL của ảnh
        });

        // Sau khi lưu, reset các trường dữ liệu
        _nameController.clear();
        _priceController.clear();
        _typeController.clear();
        _image = null;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm sản phẩm thành công!')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi thêm sản phẩm: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Vui lòng nhập đầy đủ thông tin và chọn hình ảnh')),
      );
    }
  }

  Future<void> _deleteProduct(String id) async {
    try {
      // Xóa ảnh từ Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('ProductImages/$id');
      await storageRef.delete();

      // Xóa sản phẩm từ Realtime Database
      await _dbRef.child(id).remove();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa sản phẩm thành công!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa sản phẩm: $error')),
      );
    }
  }

  void _editProduct(Map<String, dynamic> product) {
    setState(() {
      _editingProductId = product['id'];
      _nameController.text = product['name'];
      _priceController.text = product['price'];
      _typeController.text = product['type'];
      _image = null; // Không cập nhật hình ảnh khi chỉnh sửa
    });
  }

  Future<void> _updateProduct() async {
    if (_editingProductId != null &&
        _nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _typeController.text.isNotEmpty) {
      try {
        // Cập nhật sản phẩm trong Realtime Database
        await _dbRef.child(_editingProductId!).update({
          'Name': _nameController.text,
          'Price': _priceController.text,
          'Type': _typeController.text,
          // 'Image': Nếu muốn cập nhật hình ảnh thì thêm ở đây
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật sản phẩm thành công!')),
        );

        // Reset sau khi cập nhật
        _editingProductId = null;
        _nameController.clear();
        _priceController.clear();
        _typeController.clear();
        _image = null;
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi cập nhật sản phẩm: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý sản phẩm',
          style: TextStyle(fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _editingProductId == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                style: TextStyle(color: Colors.white)),
            TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Giá sản phẩm'),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white)),
            TextField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Loại sản phẩm'),
                style: TextStyle(color: Colors.white)),
            SizedBox(height: 16),
            _image != null
                ? Image.file(
              _image!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            )
                : Text('Chưa chọn hình ảnh'),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Chọn hình ảnh'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _editingProductId == null ? _addProduct : _updateProduct,
              child: Text(_editingProductId == null ? 'Thêm' : 'Cập nhật'),
            ),
            SizedBox(height: 32),
            Text(
              'Danh sách sản phẩm',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(product['name']),
                      subtitle: Text(
                          'Giá: ${product['price']} - Loại: ${product['type']}'),
                      leading: product['image'] != null
                          ? Image.network(
                        product['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : Icon(Icons.image),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editProduct(product);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteProduct(product['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
