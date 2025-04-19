// lib/root_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:t2305m_app/screen/cart/cart_screen.dart';
import 'package:t2305m_app/screen/home/home_screen.dart';
import 'package:t2305m_app/screen/profile/profile_screen.dart';
import 'package:t2305m_app/screen/search/search_screen.dart';

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
            const Divider(),
            const SizedBox(height: 16.0),
            ExpansionTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.help_outline, color: Colors.white),
              ),
              title: const Text("Câu hỏi thường gặp"),
              subtitle: const Text(
                "Xem hướng dẫn lấy lại mật khẩu, đăng nhập, đăng ký, liên kết thông tin học sinh",
              ),
              children: const <Widget>[
                ListTile(
                  title: Text("Làm sao để lấy lại mật khẩu?"),
                  subtitle: Text("Nhấn vào 'Quên mật khẩu' tại màn hình đăng nhập và làm theo hướng dẫn."),
                ),
                ListTile(
                  title: Text("Cách đăng nhập vào tài khoản?"),
                  subtitle: Text("Nhập email và mật khẩu của bạn, sau đó nhấn 'Đăng nhập'."),
                ),
                ListTile(
                  title: Text("Làm sao để đăng ký tài khoản?"),
                  subtitle: Text("Điền đầy đủ thông tin tại màn hình đăng ký và nhấn 'Đăng ký'."),
                ),
                ListTile(
                  title: Text("Cách liên kết thông tin học sinh?"),
                  subtitle: Text("Vào phần 'Thông tin cá nhân' và chọn 'Liên kết học sinh', sau đó làm theo hướng dẫn."),
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
  final bool isAdmin;
  const RootPage({super.key, this.isAdmin = false});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
    CartScreen(),
  ];

  int _selectedIndex = 0;

  void changeScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

// Thay thế toàn bộ hàm build của _RootPageState bằng phần dưới:

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "Baby",
                  style: TextStyle(
                    color: Color(0xFFFF4880),
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "Care",
                  style: TextStyle(
                    color: Color(0xFF4D65F9),
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SupportScreen()),
              );
            },
            icon: const FaIcon(FontAwesomeIcons.headphonesAlt, color: Colors.blue, size: 18),
            label: const Text(
              "Hỗ trợ",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.black54,
          currentIndex: _selectedIndex,
          onTap: changeScreen,
          items: [
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house),
              label: "Trang chủ",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.widgets_outlined),
              label: "Tiện ích",
            ),
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.bell),
              label: "Thông báo",
            ),
            if (!widget.isAdmin)
              const BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user),
                label: "Cá nhân",
              ),
          ],
        ),
      ),
    );
  }

}