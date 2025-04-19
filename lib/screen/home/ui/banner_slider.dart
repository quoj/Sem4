import 'package:flutter/material.dart';
import 'package:t2305m_app/models/user.dart';
import 'package:t2305m_app/api/api_service.dart';
import 'package:dio/dio.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  late ApiService apiService;
  late Future<List<User>> users;
  String? avatarPath;
  String? userName;
  String? studentId;
  String? schoolName;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    users = apiService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Nền trắng cho toàn giao diện
      child: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi khi tải dữ liệu người dùng'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu người dùng'));
          } else {
            final user = snapshot.data!.first; // Lấy người dùng đầu tiên

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề với thông tin người dùng và avatar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Avatar
                          GestureDetector(
                            onTap: () async {
                              String? newAvatarPath = await _selectAvatar();
                              if (newAvatarPath != null) {
                                setState(() {
                                  avatarPath = newAvatarPath;
                                });
                              }
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade300, // Màu nền mặc định
                              backgroundImage: avatarPath != null
                                  ? AssetImage(avatarPath!)
                                  : null, // Hiển thị ảnh đã chọn nếu có
                              child: avatarPath == null
                                  ? Icon(
                                Icons.person, // Icon mặc định khi chưa có ảnh
                                size: 30,
                                color: Colors.white,
                              )
                                  : null,
                            ),
                          ),
                          SizedBox(width: 10),
                          // Thông tin người dùng
                          GestureDetector(
                            onTap: () {
                              _showUserInfoDialog(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "🧒 ",
                                        style: TextStyle(fontSize: 16), // icon nhỏ hơn
                                      ),
                                      TextSpan(
                                        text: user.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "🆔 ",
                                        style: TextStyle(fontSize: 14), // icon nhỏ hơn
                                      ),
                                      TextSpan(
                                        text: "Mã HS: ${user.id}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "🏫 ",
                                        style: TextStyle(fontSize: 14), // icon nhỏ hơn
                                      ),
                                      TextSpan(
                                        text: schoolName ?? 'Tên trường',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                            ),
                          ),
                        ],
                      ),
                      // Ký tự ˇ Unicode
                      GestureDetector(
                        onTap: () {
                          _showChildSelection(context);
                        },
                        child: Text(
                          "\u02C7", // Ký tự ˇ
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
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

  // Hàm giả lập chọn ảnh
  Future<String?> _selectAvatar() async {
    // Trả về đường dẫn ảnh được chọn
    return null; // Trả về null nếu không chọn ảnh
  }

  // Hàm hiển thị bảng chọn con
  void _showChildSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white, // Nền trắng cho Bottom Sheet
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Chọn con",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddChildScreen()),
                  );
                },
                child: Text(
                  "+ Thêm con",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm hiển thị thông tin người dùng
  void _showUserInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Nền trắng cho hộp thoại
          title: Text(
            "Thông tin tài khoản",
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tên người dùng: ${userName ?? 'Chưa có tên'}",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Mã HS: ${studentId ?? 'Chưa có mã'}",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Tên trường: ${schoolName ?? 'Chưa có trường'}",
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Đóng",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}


class AddChildScreen extends StatelessWidget {
  const AddChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng cho toàn màn hình
      appBar: AppBar(
        backgroundColor: Colors.white, // Thanh tiêu đề nền trắng
        title: const Text("Thêm con", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black), // Nút back màu đen
        elevation: 1, // Đường viền nhẹ dưới AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mã học sinh",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Nhập mã học sinh",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý sự kiện khi bấm xác nhận
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Nền xanh dương
                  foregroundColor: Colors.white, // Chữ trắng
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text("Xác nhận"),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Mỗi học sinh sẽ có một mã học sinh duy nhất.\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    TextSpan(
                      text: "Phụ huynh vui lòng liên hệ Nhà trường để nhận mã học sinh của con.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}