import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../api/api_service.dart';
import '../../../models/announcements.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedCategory = 'Chung';
  List<Announcement> announcements = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  void _updateNotification(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Future<void> _fetchAnnouncements() async {
    setState(() => isLoading = true);
    try {
      ApiService apiService = ApiService(Dio());
      List<Announcement> data = await apiService.getAnnouncements();
      setState(() {
        announcements = data;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi API: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _updateNotification('Về con'),
                child: const Text('Về con'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _updateNotification('Bảng tin'),
                child: const Text('Bảng tin'),
              ),
            ],
          ),
          Expanded(
            child: selectedCategory == 'Chung' || selectedCategory == 'Bảng tin'
                ? _buildBulletin()
                : _buildDefaultNotification(),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultNotification() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.notifications_none, size: 100, color: Colors.blue),
          const SizedBox(height: 20),
          Text(
            _getNotificationText(),
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBulletin() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (announcements.isEmpty) {
      return const Center(child: Text('Không có thông báo nào'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        return _buildAnnouncementCard(announcements[index]);
      },
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(announcement.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(announcement.content),
            const SizedBox(height: 5),
            Text('Tác giả: ${announcement.author}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 5),
            announcement.imagePath.isNotEmpty
                ? Image.network(
              "http://10.0.2.2:8080/${announcement.imagePath}",
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100),
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  String _getNotificationText() {
    switch (selectedCategory) {
      case 'Về con':
        return 'Thông báo về con: Không có thông báo mới';
      case 'Bảng tin':
      case 'Chung':
        return 'Đang tải thông báo...';
      default:
        return 'Chưa có thông báo nào';
    }
  }
}