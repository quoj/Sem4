import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final String userName = "Nguyễn Văn A";
  final String studentId = "12345"; // Mã HS
  final String schoolName = "Trường Mầm Non Hoa Súng"; // Tên trường

  // Biến lưu đường dẫn ảnh đại diện, nếu null thì dùng khung mặc định
  String? avatarPath;

  @override
  Widget build(BuildContext context) {
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
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Mã HS: $studentId",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          schoolName,
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

  // Hàm giả lập chọn ảnh
  Future<String?> _selectAvatar() async {
    // Trả về đường dẫn ảnh được chọn
    return null; // Trả về null nếu không chọn ảnh
  }

  // Hàm hiển thị bảng chọn con
  void _showChildSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
                    MaterialPageRoute(builder: (context) => AddChildScreen()),
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
          title: Text("Thông tin tài khoản"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tên người dùng: $userName"),
              Text("Mã HS: $studentId"),
              Text("Tên trường: $schoolName"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Đóng"),
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
      appBar: AppBar(
        title: Text("Thêm con"),
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
                  // Hàm xác nhận
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Màu nền xanh dương
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
                      text: "Mỗi học sinh sẽ có một mã học sinh duy\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                    TextSpan(
                      text: "nhất.\n",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15// lighter font weight
                      ),
                    ),
                    TextSpan(
                      text: "Phụ huynh vui lòng liên hệ Nhà trường để\n",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15
                      ),
                    ),
                    TextSpan(
                      text: "nhận mã học sinh của con.",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15
                        // lighter font weight
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