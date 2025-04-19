import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tiện ích"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          // Danh sách các tiện ích

          Divider(),
          ListTile(
            leading: Icon(Icons.search, color: Colors.blue),
            title: Text("Tra cứu hồ sơ "),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdmissionLookupScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.book, color: Colors.blue),
            title: Text("Hướng dẫn sử dụng"),
          ),
          Divider(),
          // Phần trống để có thể thêm các mục khác
          Spacer(),
        ],
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán học phí"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: "Mã học sinh",
                hintText: "Nhập mã học sinh",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Thực hiện kiểm tra mã học sinh tại đây
              },
              child: const Text("Kiểm tra"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Mỗi học sinh sẽ có một mã học sinh duy nhất. Phụ huynh vui lòng liên hệ Nhà trường để nhận mã học sinh của con.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class AdmissionLookupScreen extends StatelessWidget {
  const AdmissionLookupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tra cứu"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: "Nhập số điện thoại",
                hintText: "Nhập số điện thoại",
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: "Nhập ngày sinh của con (Vd: 08/08/2002)",
                hintText: "Nhập ngày sinh của con (Vd: 08/08/2002)",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Thực hiện tra cứu hồ sơ tuyển sinh tại đây
              },
              child: const Text("Tra cứu"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Phụ huynh vui lòng nhập số điện thoại và ngày sinh của con theo đúng thông tin đã nộp trong hồ sơ tuyển sinh để tra cứu kết quả.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}