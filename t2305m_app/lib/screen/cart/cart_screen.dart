import 'package:flutter/material.dart';
import 'package:t2305m_app/models/user.dart';
import 'package:t2305m_app/api/api_service.dart';
import 'package:dio/dio.dart';
import 'package:t2305m_app/screen/auth/login_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService(Dio());
    final Future<List<User>> users = apiService.getUsers();

    return Scaffold(
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Lỗi khi tải dữ liệu người dùng'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có dữ liệu người dùng'));
          } else {
            final user = snapshot.data!.first;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Thông tin phụ huynh từ API
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        radius: 30,
                        child: const Icon(Icons.person, color: Colors.white, size: 40),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phụ huynh: ${user.name}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text("Mã HS: ${user.id}"),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // Các mục tiện ích
                ListTile(
                  leading: const Icon(Icons.child_care, color: Colors.blue),
                  title: const Text("Quản lý thông tin con"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditChildInfoScreen()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock, color: Colors.blue),
                  title: const Text("Đổi mật khẩu"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                    );
                  },
                ),
                const Divider(),

                // Trung tâm trợ giúp và Đăng xuất
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Bạn đang gặp vấn đề cần hỗ trợ ?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Image.asset(
                                      'assets/images/QA.png',
                                      width: 48,
                                      height: 48,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.lightBlue.shade100,
                                        foregroundColor: Colors.lightBlue.shade600,
                                      ),
                                      child: const Text("Trung tâm trợ giúp"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          icon: const Icon(Icons.logout, color: Colors.red),
                          label: const Text(
                            "Đăng xuất",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hỗ trợ"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước đó
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 16.0),
          ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: const Icon(Icons.help_outline, color: Colors.white),
            ),
            title: const Text("Câu hỏi thường gặp"),
            subtitle: const Text(
              "Xem hướng dẫn lấy lại mật khẩu, đăng nhập, đăng ký, liên kết thông tin học sinh",
            ),
            children: <Widget>[
              ListTile(
                title: const Text("Làm sao để lấy lại mật khẩu?"),
                subtitle: const Text("Để lấy lại mật khẩu, bạn có thể nhấn vào nút 'Quên mật khẩu' tại màn hình đăng nhập và làm theo hướng dẫn."),
              ),
              ListTile(
                title: const Text("Cách đăng nhập vào tài khoản?"),
                subtitle: const Text("Để đăng nhập, bạn nhập email và mật khẩu của bạn, sau đó nhấn vào nút 'Đăng nhập'."),
              ),
              ListTile(
                title: const Text("Làm sao để đăng ký tài khoản?"),
                subtitle: const Text("Để đăng ký tài khoản, bạn cần điền đầy đủ thông tin yêu cầu tại màn hình đăng ký và nhấn nút 'Đăng ký'."),
              ),
              ListTile(
                title: const Text("Cách liên kết thông tin học sinh?"),
                subtitle: const Text("Để liên kết thông tin học sinh, bạn vào phần 'Thông tin cá nhân' và chọn 'Liên kết học sinh', sau đó làm theo hướng dẫn."),
              ),
            ],
          ),
        ],
      ),

    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Mật khẩu cũ",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "Mật khẩu mới",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "Xác nhận mật khẩu mới",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Xử lý đổi mật khẩu
              },
              child: const Text("Đổi mật khẩu"),
            ),
          ],
        ),
      ),
    );
  }
}

class EditChildInfoScreen extends StatelessWidget {
  const EditChildInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa thông tin con"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Tên hiển thị",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "Ngày sinh",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Mã học sinh",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    // Xử lý sao chép
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Xử lý lưu thay đổi
              },
              child: const Text("Lưu thay đổi"),
            ),
          ],
        ),
      ),
    );
  }
}

