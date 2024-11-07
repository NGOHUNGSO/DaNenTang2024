import 'dart:io';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý sản phẩm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _typeController = TextEditingController();
  File? _image;
  String? _editingProductId;

  final ImagePicker _picker = ImagePicker();
  final DatabaseReference _productRef =
  FirebaseDatabase.instance.ref().child('Product');

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProductImage(String productId) async {
    if (_image != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images/$productId.jpg');
      await storageRef.putFile(_image!);
      final imageUrl = await storageRef.getDownloadURL();
      await _productRef.child(productId).update({'image': imageUrl});
    }
  }

  Future<void> _addOrUpdateProduct() async {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _typeController.text.isNotEmpty) {
      if (_editingProductId == null) {
        // Thêm sản phẩm mới
        final newProductRef = _productRef.push();
        await newProductRef.set({
          'name': _nameController.text,
          'price': _priceController.text,
          'type': _typeController.text,
          'image': '', // Lưu tạm ảnh trống, sau khi upload sẽ cập nhật lại
        });
        await _uploadProductImage(newProductRef.key!);
      } else {
        // Cập nhật sản phẩm hiện tại
        await _productRef.child(_editingProductId!).update({
          'name': _nameController.text,
          'price': _priceController.text,
          'type': _typeController.text,
        });
        await _uploadProductImage(_editingProductId!);
      }

      // Sau khi thêm hoặc cập nhật, xóa các nội dung trong ô nhập
      _clearInputFields();
    }
  }

  void _clearInputFields() {
    _nameController.clear();
    _priceController.clear();
    _typeController.clear();
    setState(() {
      _image = null;
      _editingProductId = null;
    });
  }

  void _editProduct(Map product, String productId) {
    setState(() {
      _nameController.text = product['name'];
      _priceController.text = product['price'];
      _typeController.text = product['type'];
      _editingProductId = productId;
      _image = null; // Đặt lại ảnh để đảm bảo cập nhật ảnh mới khi cần
    });
  }

  Future<void> _deleteProduct(String productId) async {
    await _productRef.child(productId).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _editingProductId == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên sản phẩm'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Giá sản phẩm'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Loại sản phẩm'),
            ),
            SizedBox(height: 16),
            _image != null
                ? Image.file(_image!, width: 100, height: 100, fit: BoxFit.cover)
                : Text('Chưa chọn hình ảnh'),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Chọn hình ảnh'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addOrUpdateProduct,
              child: Text(_editingProductId == null ? 'Thêm' : 'Lưu'),
            ),
            SizedBox(height: 32),
            Text(
              'Danh sách sản phẩm',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                query: _productRef,
                itemBuilder: (context, snapshot, animation, index) {
                  final product = Map<String, dynamic>.from(snapshot.value as Map);
                  final productId = snapshot.key!;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: product['image'] != ''
                          ? Image.network(product['image'],
                          width: 50, height: 50, fit: BoxFit.cover)
                          : Container(width: 50, height: 50, color: Colors.grey),
                      title: Text(product['name']),
                      subtitle: Text('Giá: ${product['price']} - Loại: ${product['type']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editProduct(product, productId),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteProduct(productId),
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
