import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedCategory = 'Chung'; // Mặc định hiển thị thông báo chung

  void _updateNotification(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _updateNotification('Về con'),
                child: Text('Về con'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _updateNotification('Bảng tin'),
                child: Text('Bảng tin'),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.notifications_none,
                    size: 100,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 20),
                  Text(
                    _getNotificationText(),
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getNotificationText() {
    switch (selectedCategory) {
      case 'Về con':
        return 'Thông báo về con: Không có thông báo mới';
      case 'Bảng tin':
        return 'Thông báo bảng tin: Không có thông báo mới';
      default:
        return 'Chưa có thông báo nào';
    }
  }
}
