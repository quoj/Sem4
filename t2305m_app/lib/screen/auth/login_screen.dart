import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:t2305m_app/root_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _StateLogin createState() => _StateLogin();
}

class _StateLogin extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _rememberMe = false; // Checkbox remember me

  login() async {
    // Gọi API đăng nhập ở đây
    print(emailController.text);
    print(passwordController.text);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const RootPage())
    );
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 100.0, horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sửa phần tiêu đề "BabyCare" thành RichText
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Baby",
                      style: TextStyle(
                        color: Color(0xFFFF4880), // Màu của "Baby"
                        fontSize: 48.0, // Tăng kích thước chữ
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Care",
                      style: TextStyle(
                        color: Color(0xFF4D65F9), // Màu của "Care"
                        fontSize: 48.0, // Tăng kích thước chữ
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),


            const SizedBox(height: 10),
            const SizedBox(height: 10),

            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)), // Bo tròn viền
                ),
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: _hidePassword,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)), // Bo tròn viền
                ),
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Log in",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Thêm màu chữ cho nút "Log in"
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}
