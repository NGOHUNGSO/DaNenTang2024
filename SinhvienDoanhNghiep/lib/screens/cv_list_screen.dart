import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CvListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách CV"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: FirebaseDatabase.instance.ref('sinhvien/khoa/2021/lop/21SE3').onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError && snapshot.data!.snapshot.value != null) {
              final data = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final student = data.values.elementAt(index);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: student['Avata'] != null
                          ? NetworkImage(student['Avata'])
                          : AssetImage('assets/default_avatar.png') as ImageProvider,
                    ),
                    title: Text(student['HoTen'] ?? "-"),
                    subtitle: Text(student['Gmail'] ?? "-"),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}