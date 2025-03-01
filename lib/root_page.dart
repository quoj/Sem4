import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:t2305m_flutter/screen/cart/cart_screen.dart';
import 'package:t2305m_flutter/screen/home/home_screen.dart';
import 'package:t2305m_flutter/screen/profile/profile_screen.dart';
import 'package:t2305m_flutter/screen/search/search_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hỗ trợ",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Divider(), // Dòng phân cách giữa các mục
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
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  // Danh sách các màn hình
  final List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
    CartScreen(),
  ];

  // Chỉ số màn hình được chọn
  int _selectedIndex = 0;

  // Hàm thay đổi màn hình
  void changeScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thanh AppBar
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Baby",
                    style: TextStyle(
                      color: Color(0xFFFF4880),
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "Care",
                    style: TextStyle(
                      color: Color(0xFF4D65F9),
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white, // Đổi từ màu hồng thành màu trắng
        actions: [
          Row(
            children: [
              IconButton(
                icon: FaIcon(FontAwesomeIcons.headphonesAlt, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SupportScreen()),
                  );
                },
              ),
              const Text(
                "Hỗ trợ",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ), // <--- THÊM DẤU PHẨY Ở ĐÂY!!!


      // Nội dung màn hình
      body: Column(
        children: [
          Expanded(
            child: screens[_selectedIndex],
          ),
        ],
      ),

      // Thanh BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userAlt), // Biểu tượng người dùng
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets), // Biểu tượng tiện ích
            label: "Tiện ích",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bell),
            label: "Notification",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // Biểu tượng thiết lập
            label: "Settings",
          ),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black87,
        currentIndex: _selectedIndex,
        onTap: changeScreen,
      ),
    );
  }
}

