import 'package:flutter/material.dart';
import 'package:t2305m_app/screen/auth/login_screen.dart';
import 'package:t2305m_app/root_page.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Chào mừng Admin!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Đăng xuất"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 2),
          const Expanded(child: RootPage(isAdmin: true)),
        ],
      ),
    );
  }
}

class AttendancePage extends StatelessWidget {
  final bool isAdmin;
  const AttendancePage({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Điểm danh")),
      body: Center(
        child: isAdmin
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.qr_code, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text("Quét mã QR để điểm danh", style: TextStyle(fontSize: 18)),
          ],
        )
            : const Text("Danh sách điểm danh sẽ hiển thị ở đây", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
