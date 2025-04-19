import 'package:dio/dio.dart';
import 'package:t2305m_app/api/api_service.dart';
import 'package:t2305m_app/models/feedback.dart';
import 'package:t2305m_app/models/schedule.dart';
import 'package:t2305m_app/models/messages.dart';
import 'package:t2305m_app/models/tuition.dart';
import 'package:t2305m_app/models/health.dart';
import 'package:t2305m_app/models/menu.dart';
import 'package:t2305m_app/models/attendance.dart';
import 'package:t2305m_app/models/leave_requests.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:t2305m_app/model/category.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../models/study_comments.dart';
import '../../../models/study_results.dart';
import '../../../models/images.dart';
import 'category_item.dart' as _tabController;

class CategoryItem extends StatelessWidget {
  final Category category;
  final int imageIndex;

  const CategoryItem({super.key,
    required this.category,
    required this.imageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      "assets/images/basketball_7108306.png",
      "assets/images/task_9012120.png",
      "assets/images/unnamed.png",
      "assets/images/hocphi.png",
      "assets/images/thucdon.png",
      "assets/images/suckhoe.png",
      "assets/images/thuvienanh.jpg",
      "assets/images/gopy.jpg",
    ];

    final List<String> imageLabels = [
      "Hoạt động",
      "Lời nhắn",
      "Điểm danh",
      "Học phí",
      "Thực đơn",
      "Sức khỏe",
      "Thư viện ",
      "Góp ý",
    ];

    final List<Widget> pages = [
      SchedulePage(),
      MessagePage(),
      AttendancePage(),
      TuitionPage(),
      StudyPage(),
      HealthPage(),
      ContactsPage(),
      FeedbackPage(),
    ];

    final imageUrl = imageUrls[imageIndex % imageUrls.length];
    final imageLabel = imageLabels[imageIndex % imageLabels.length];
    final targetPage = pages[imageIndex % pages.length];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Column(
        children: [
          Column(
            children: [
              imageUrl.startsWith('assets')
                  ? Image.asset(
                imageUrl,
                width: 40.0,
                height: 40.0,
                fit: BoxFit.cover,
              )
                  : Image.network(
                imageUrl,
                width: 40.0,
                height: 40.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Text(
                imageLabel,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}


// Các trang mẫu
class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late ApiService apiService;
  List<Schedule> schedules = [];
  DateTime selectedDate = DateTime.now();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    fetchSchedules();
  }

  void fetchSchedules() async {
    try {
      List<Schedule> data = await apiService.getSchedules();
      setState(() {
        schedules = data;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi API: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    List<Schedule> filteredSchedules = schedules
        .where((s) => DateFormat('yyyy-MM-dd').format(s.dayOfWeek) == currentDate)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Thời khóa biểu")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ngày: $currentDate", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  _buildHorizontalDayList(),
                  const SizedBox(height: 20),
                  const Text("Thời khóa biểu:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  filteredSchedules.isNotEmpty
                      ? Text(
                    filteredSchedules.first.subjectId,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.blue),
                  )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: filteredSchedules.map((schedule) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.book, color: Colors.blue),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(schedule.subjectId, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text(
                                  "${DateFormat('HH:mm').format(schedule.startTime)} - ${DateFormat('HH:mm').format(schedule.endTime)} | GV: ${schedule.teacherId}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudyPage1()),
          );
        },
        backgroundColor: Colors.blue,
        tooltip: "Góc học tập",
        child: const Icon(Icons.school),
      ),
    );
  }

  Widget _buildHorizontalDayList() {
    DateTime today = DateTime.now();
    List<Widget> dayWidgets = [];

    for (int i = 0; i < 7; i++) {
      DateTime currentDay = today.add(Duration(days: i));
      String dayNumber = DateFormat('dd').format(currentDay);
      bool isSelected = currentDay.day == selectedDate.day &&
          currentDay.month == selectedDate.month &&
          currentDay.year == selectedDate.year;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = currentDay;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    dayNumber,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(DateFormat('EEE').format(currentDay), style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: dayWidgets,
      ),
    );
  }
}





class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late ApiService apiService;
  List<Message> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    fetchMessages();
  }

  void fetchMessages() async {
    try {
      List<Message> data = await apiService.getMessage();
      setState(() {
        messages = data;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi API: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lời nhắn")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : messages.isEmpty
            ? const Center(child: Text("Không có lời nhắn nào."))
            : ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            Message message = messages[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message.createdAt.toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        message.status,
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (message.imagePath != null &&
                      message.imagePath!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.network(
                        message.imagePath!, // Đã kiểm tra null trước đó
                        height: 150,
                        width: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 50),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    message.status == "confirmed"
                        ? "Tin nhắn đã xác nhận"
                        : "Tin nhắn chưa xác nhận",
                    style: const TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMessagePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


class AddMessagePage extends StatefulWidget {
  const AddMessagePage({super.key});

  @override
  _AddMessagePageState createState() => _AddMessagePageState();
}

class _AddMessagePageState extends State<AddMessagePage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  File? _selectedImage;
  final ApiService _apiService = ApiService(Dio());

  bool _isLoading = false; // Trạng thái loading

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path),
      });

      Response response = await Dio().post("http://10.0.2.2:8080/messages", data: formData);

      if (response.statusCode == 200) {
        return response.data['imageUrl']; // Giả sử server trả về URL ảnh đã upload
      }
    } catch (e) {
      print("Lỗi khi upload ảnh: $e");
    }
    return null;
  }

  Future<void> _sendMessage() async {
    if (_dateController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadImage(_selectedImage!);
      }

      Message newMessage = Message(
        id: 0, // Server sẽ tự tạo ID
        senderId: 1, // Cập nhật theo người dùng
        receiverId: 2, // Cập nhật theo người nhận
        studentId: 3, // ID học sinh
        content: _messageController.text,
        imagePath: imageUrl,
        status: "pending",
        createdAt: DateTime.now(),
      );

      await _apiService.sendMessage(newMessage);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gửi lời nhắn thành công!")),
      );

      Navigator.pop(context, true); // Quay lại trang trước và cập nhật danh sách
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi khi gửi lời nhắn!")),
      );
      print("Lỗi khi gửi tin nhắn: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm lời nhắn")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: "Nhắn cho ngày *",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.image, size: 50, color: Colors.grey),
                    Text("Thêm hình ảnh", style: TextStyle(color: Colors.grey)),
                  ],
                )
                    : Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Nội dung *",
                hintText:
                "Nhập lời nhắn muốn gửi đến giáo viên (VD: nhờ cô giáo lưu ý về sức khỏe của con, cho con uống thuốc...)",
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendMessage, // Disable nút khi đang gửi
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Gửi"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ApiService apiService;
  List<Attendance> attendances = [];
  List<LeaveRequest> leaveRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    apiService = ApiService(Dio(), baseUrl: "http://10.0.2.2:8080");
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await Future.wait([
        apiService.getAttendances(),
        apiService.getLeaveRequests(),
      ]);
      setState(() {
        attendances = data[0] as List<Attendance>;
        leaveRequests = data[1] as List<LeaveRequest>;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Điểm danh"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Điểm danh"),
            Tab(text: "Đơn xin nghỉ"),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _buildAttendanceTab(),
          _buildLeaveRequestTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showLeaveRequestForm,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildAttendanceTab() {
    if (attendances.isEmpty) {
      return Center(child: Text("Không có dữ liệu điểm danh."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: attendances.length,
      itemBuilder: (context, index) {
        final a = attendances[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            title: Text("Ngày: ${DateFormat('dd/MM/yyyy').format(a.date)}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Trạng thái: ${_translateStatus(a.status)}"),
                if (a.note != null) Text("Ghi chú: ${a.note}"),
              ],
            ),
            trailing: Icon(
              a.status == "present"
                  ? Icons.check_circle
                  : a.status == "absent"
                  ? Icons.cancel
                  : Icons.access_time,
              color: a.status == "present"
                  ? Colors.green
                  : a.status == "absent"
                  ? Colors.red
                  : Colors.orange,
            ),
          ),
        );
      },
    );
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'present':
        return 'Có mặt';
      case 'absent':
        return 'Vắng';
      case 'late':
        return 'Đi muộn';
      default:
        return 'Không rõ';
    }
  }

  Widget _buildLeaveRequestTab() {
    if (leaveRequests.isEmpty) {
      return Center(child: Text("Chưa có đơn xin nghỉ."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: leaveRequests.length,
      itemBuilder: (context, index) {
        final request = leaveRequests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ngày: ${request.date}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("Lý do: ${request.reason}", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text("Trạng thái: ${request.status ?? 'Chờ xác nhận'}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
                SizedBox(height: 8),
                if (request.requestTime != null)
                  Text("Gửi lúc: ${request.requestTime}", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLeaveRequestForm() {
    final _dateController = TextEditingController();
    final _reasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Thêm đơn xin nghỉ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Ngày xin nghỉ (yyyy-MM-dd)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: 'Lý do xin nghỉ',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final newRequest = LeaveRequest(
                    id: 0, // ID sẽ được server gán
                    studentId: 1, // Thay bằng ID thực tế nếu có đăng nhập
                    reason: _reasonController.text,
                    date: _dateController.text,
                    status: "Chờ xác nhận",
                    requestTime: DateFormat('HH:mm').format(DateTime.now()),
                  );
                  try {
                    final created = await apiService.createLeaveRequest(newRequest);
                    setState(() {
                      leaveRequests.add(created);
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    print("Error sending leave request: $e");
                    Navigator.pop(context);
                  }
                },
                child: Text('Gửi đơn'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TuitionPage extends StatefulWidget {
  const TuitionPage({super.key});

  @override
  _TuitionPageState createState() => _TuitionPageState();
}

class _TuitionPageState extends State<TuitionPage> {
  late ApiService apiService;
  bool isLoading = true;
  List<Tuition> tuitions = [];

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio()); // Khởi tạo ApiService
    fetchTuitionData(); // Lấy dữ liệu học phí khi trang được tải
  }

  // Hàm lấy dữ liệu học phí từ API
  void fetchTuitionData() async {
    try {
      final data = await apiService.getTuitions(); // Gọi API
      setState(() {
        tuitions = data; // Cập nhật dữ liệu vào danh sách
        isLoading = false; // Đổi trạng thái khi lấy dữ liệu xong
      });
    } catch (e) {
      print("Error fetching tuition data: $e");
      setState(() {
        isLoading = false; // Đổi trạng thái khi có lỗi
      });
    }
  }

  // Hàm tính tổng số tiền học phí
  double calculateTotalAmount() {
    double total = 0;
    for (var tuition in tuitions) {
      total += tuition.amount ?? 0;
    }
    return total;
  }

  // Hàm định dạng số tiền
  String formatCurrency(double amount) {
    final format = NumberFormat("#,###", "vi_VN"); // Định dạng số với dấu phân cách
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tiền học")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Hiển thị loading
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cần thanh toán",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 3,
              child: ListTile(
                title: const Text("Hóa đơn chờ thanh toán"),
                subtitle: const Text("Đợt 1 tháng 03/2023"),
                trailing: Text(
                  formatCurrency(2056080), // Định dạng số tiền
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            Card(
              elevation: 3,
              child: ListTile(
                title: const Text("Đăng ký: Chăm sóc bán trú, Đồng phục"),
                subtitle: const Text("Hạn đăng ký: 09/04/2023"),
                trailing: const Text(
                  "Hết hạn",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Số còn phải thanh toán",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              formatCurrency(calculateTotalAmount()), // Hiển thị số tiền với định dạng
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Đợt 1 THÁNG 03/2023",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: tuitions.length, // Dùng số lượng từ dữ liệu API
                itemBuilder: (context, index) {
                  final tuition = tuitions[index]; // Lấy từng mục học phí
                  return ListTile(
                    title: Text(tuition.description ?? "Không có mô tả"),
                    subtitle: Text(
                      "Ngày: ${tuition.tuitionDate ?? 'Chưa có ngày'}",
                    ),
                    trailing: Text(
                      formatCurrency(tuition.amount ?? 0), // Định dạng số tiền
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class StudyPage extends StatefulWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  late ApiService apiService;
  bool isLoading = true;
  List<Menu> menus = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    fetchMenuData();
  }

  void fetchMenuData() async {
    try {
      print("🟡 Gọi API: Lấy danh sách thực đơn...");
      final data = await apiService.getMenus();
      print("✅ Dữ liệu thực đơn: $data");
      setState(() {
        menus = data;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Lỗi khi lấy thực đơn: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = selectedDate;
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weekDates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
    final selectedMenus = menus.where((menu) =>
    DateFormat('yyyy-MM-dd').format(menu.date) == DateFormat('yyyy-MM-dd').format(selectedDate)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Thực đơn theo ngày")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : menus.isEmpty
          ? const Center(child: Text("Không có dữ liệu thực đơn"))
          : Column(
        children: [
          // Thanh chọn ngày
          Container(
            color: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          selectedDate = selectedDate.subtract(const Duration(days: 7));
                        });
                      },
                    ),
                    Text(
                      "Tháng ${DateFormat('MM, yyyy').format(selectedDate)}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          selectedDate = selectedDate.add(const Duration(days: 7));
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weekDates.length,
                    itemBuilder: (context, index) {
                      final date = weekDates[index];
                      final isSelected = DateFormat('yyyy-MM-dd').format(date) ==
                          DateFormat('yyyy-MM-dd').format(selectedDate);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                        child: Container(
                          width: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.orange.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('dd').format(date),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.orange : Colors.white,
                                ),
                              ),
                              Text(
                                date.weekday == 7 ? "CN" : "T.${date.weekday + 1}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected ? Colors.orange : Colors.white70,
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Danh sách thực đơn
          Expanded(
            child: selectedMenus.isEmpty
                ? const Center(child: Text("Không có thực đơn hôm nay"))
                : ListView.builder(
              itemCount: selectedMenus.length,
              itemBuilder: (context, index) {
                final menu = selectedMenus[index];
                final isToday = DateFormat('yyyy-MM-dd').format(menu.date) == DateFormat('yyyy-MM-dd').format(DateTime.now());

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ngày ${DateFormat('dd/MM/yyyy').format(menu.date)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (isToday)
                              const Icon(Icons.star, color: Colors.yellowAccent),
                          ],
                        ),
                      ),
                      buildMealBox(
                        title: "Bữa sáng",
                        meal: menu.breakfast,
                        bgColor: Colors.lightBlue.shade100,
                        imagePath: "assets/images/buasang.jpg", // Đường dẫn hình ảnh bữa sáng
                      ),
                      buildMealBox(
                        title: "Bữa trưa",
                        meal: menu.lunch,
                        bgColor: Colors.deepPurple.shade100,
                        imagePath: "assets/images/buatrua.jpg", // Đường dẫn hình ảnh bữa trưa
                      ),
                      buildMealBox(
                        title: "Bữa phụ",
                        meal: menu.dinner,
                        bgColor: Colors.orange.shade100,
                        imagePath: "assets/images/buaphu.jpg", // Đường dẫn hình ảnh bữa phụ
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMealBox({
    required String title,
    required String? meal,
    required Color bgColor,
    required String imagePath, // Sử dụng đường dẫn hình ảnh thay vì icon
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Đảm bảo các phần tử được căn giữa
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 6),
                Text(meal?.isNotEmpty == true ? meal! : 'Không có'),
              ],
            ),
          ),
          // Đặt ảnh bên phải và thay đổi kích thước
          Image.asset(
            imagePath,
            width: 100,  // Kích thước ảnh lớn hơn
            height: 100,
          ),
        ],
      ),
    );
  }

}





class StudyPage1 extends StatefulWidget {
  const StudyPage1({Key? key}) : super(key: key);

  @override
  _StudyPageState1 createState() => _StudyPageState1();
}

class _StudyPageState1 extends State<StudyPage1> with SingleTickerProviderStateMixin {
  late ApiService apiService;
  late TabController _tabController;

  List<FeedbackModel> feedbacks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    _tabController = TabController(length: 2, vsync: this);
    fetchFeedbacks();
  }

  void fetchFeedbacks() async {
    try {
      print("🟡 Gọi API: Lấy danh sách feedback...");
      List<FeedbackModel> data = await apiService.getFeedback();
      print("✅ Dữ liệu nhận được: $data");

      setState(() {
        feedbacks = data;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Lỗi API Feedbacks: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Góc học tập"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: "Nhận xét"),
            Tab(text: "Kết quả học tập"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCommentsTab(),
          _buildStudyResultsTab(),
        ],
      ),
    );
  }

  Widget _buildCommentsTab() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: feedbacks.length,
      itemBuilder: (context, index) {
        final feedback = feedbacks[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 3,
          child: ListTile(
            leading: const Icon(Icons.comment, color: Colors.blue),
            title: Text(feedback.content),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Trạng thái: ${feedback.status}"),
                Text("Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(feedback.createdAt)}"),
              ],
            ),
            trailing: feedback.imageUrl != null
                ? GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: InteractiveViewer(
                      child: Image.network(
                        feedback.imageUrl!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
              child: Image.network(
                feedback.imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildStudyResultsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildResultTile("Đánh giá", Icons.emoji_events, Colors.orange, _buildEvaluationDetails()),
        _buildResultTile("Chuyên cần", Icons.check_circle, Colors.blue, _buildAttendanceDetails()),
        _buildResultTile("Phiếu bé ngoan", Icons.star, Colors.green, _buildGoodStudentDetails()),
        _buildResultTile("Nhìn kỳ HS", Icons.remove_red_eye, Colors.purple, _buildProgressDetails()),
        _buildResultTile("Nhật ký lớp", Icons.book, Colors.red, _buildClassDiaryDetails()),
      ],
    );
  }


  /// Các phần chi tiết kết quả học tập (tĩnh)
  Widget _buildEvaluationDetails() {
    return _buildDetailCard([
      _buildDetailRow("Tư duy logic", "Tốt"),
      _buildDetailRow("Tập trung", "Khá"),
      _buildDetailRow("Khả năng tiếp thu", "Rất tốt"),
      _buildDetailRow("Kỹ năng giao tiếp", "Tốt"),
    ]);
  }


  Widget _buildAttendanceDetails() {
    return _buildDetailCard([
      _buildDetailRow("Số ngày đi học", "22 ngày"),
      _buildDetailRow("Số ngày nghỉ", "2 ngày"),
      _buildDetailRow("Đi học đúng giờ", "Rất tốt"),
    ]);
  }


  Widget _buildGoodStudentDetails() {
    return _buildDetailCard([
      _buildDetailRow("Thái độ học tập", "Tích cực"),
      _buildDetailRow("Hợp tác với bạn bè", "Tốt"),
      _buildDetailRow("Tham gia hoạt động", "Nhiệt tình"),
    ]);
  }


  Widget _buildProgressDetails() {
    return _buildDetailCard([
      _buildDetailRow("Tiến bộ môn Toán", "Rất tốt"),
      _buildDetailRow("Tiến bộ môn Tiếng Việt", "Khá"),
      _buildDetailRow("Thành tích cá nhân", "Có tiến bộ"),
    ]);
  }


  Widget _buildClassDiaryDetails() {
    return _buildDetailCard([
      _buildDetailRow("Hoạt động học tập", "Thực hành vẽ tranh"),
      _buildDetailRow("Hoạt động vui chơi", "Trò chơi nhóm ngoài trời"),
      _buildDetailRow("Nhận xét chung", "Lớp học vui vẻ và tích cực"),
    ]);
  }


  Widget _buildDetailCard(List<Widget> details) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: details,
        ),
      ),
    );
  }


  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        ],
      ),
    );
  }


  Widget _buildResultTile(String title, IconData icon, Color color, Widget details) {
    return Card(
      elevation: 2,
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: [details],
      ),
    );
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}




class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  late ApiService apiService;
  late Future<List<Health>> _healthData;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    _healthData = apiService.getHealth(); // Lấy dữ liệu sức khỏe từ API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sức khỏe")),
      body: FutureBuilder<List<Health>>(
        future: _healthData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Hiển thị loading khi đang tải dữ liệu
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}")); // Hiển thị lỗi nếu có
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có dữ liệu")); // Nếu không có dữ liệu
          } else {
            final health = snapshot.data![0]; // Chọn phần tử đầu tiên từ danh sách
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(health),
                  const SizedBox(height: 20),
                  _buildHealthOptions(context),
                  const SizedBox(height: 20),
                  _buildHealthNotes(health),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileCard(Health health) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: const AssetImage("assets/images/bangtin.png"), // Ảnh đại diện
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      health.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(health.birthDate, style: const TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        Icon(health.gender == "Nam" ? Icons.male : Icons.female, color: Colors.blue, size: 18),
                        Text(health.gender, style: const TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHealthStat("${health.height} cm", "Chiều cao"),
                _buildHealthStat("${health.weight} kg", "Cân nặng"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildHealthNotes(Health health) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Lưu ý về sức khỏe của bé",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              health.healthNotes,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHealthButton(Icons.show_chart, "Tăng trưởng", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GrowthPage()), // Chuyển đến trang Tăng trưởng
          );
        }),
        _buildHealthButton(Icons.health_and_safety, "Sổ sức khỏe", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HealthRecordsPage()), // Chuyển đến trang Sổ sức khỏe
          );
        }),
      ],
    );
  }

  Widget _buildHealthButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(icon, size: 40, color: Colors.blue),
                const SizedBox(height: 8),
                Text(label, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Trang Tăng trưởng
class GrowthPage extends StatelessWidget {
  const GrowthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Giả lập dữ liệu tăng trưởng
    final List<FlSpot> heightData = [
      FlSpot(1, 70),
      FlSpot(2, 75),
      FlSpot(3, 80),
      FlSpot(4, 85),
      FlSpot(5, 90),
    ];

    final List<FlSpot> weightData = [
      FlSpot(1, 8),
      FlSpot(2, 9),
      FlSpot(3, 10),
      FlSpot(4, 11),
      FlSpot(5, 12),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Tăng trưởng")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Biểu đồ tăng trưởng",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: heightData,
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.blue,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: weightData,
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.green,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) => Text('Tháng ${value.toInt()}'),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Legend(color: Colors.blue, label: "Chiều cao"),
                Legend(color: Colors.green, label: "Cân nặng"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget chú thích biểu đồ
class Legend extends StatelessWidget {
  final Color color;
  final String label;

  const Legend({required this.color, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}

// Trang Sổ sức khỏe
class HealthRecordsPage extends StatelessWidget {
  const HealthRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu
    final List<String> healthRecords = [
      "Bé bị sốt nhẹ ngày 2/3",
      "Đã tiêm phòng sởi ngày 10/3",
      "Khám tổng quát ngày 20/3 - sức khỏe tốt",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Sổ sức khỏe")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: healthRecords.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.note_alt_outlined, color: Colors.blue),
              title: Text(
                healthRecords[index],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}



class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late Future<List<Images>> _images;

  @override
  void initState() {
    super.initState();
    _images = _fetchImages();
  }

  // Hàm lấy dữ liệu hình ảnh từ API
  Future<List<Images>> _fetchImages() async {
    final dio = Dio();
    final apiService = ApiService(dio);
    try {
      return await apiService.getImages();  // Gọi API để lấy danh sách hình ảnh
    } catch (e) {
      throw Exception("Không thể tải hình ảnh");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thư viện ảnh")),
      body: FutureBuilder<List<Images>>(
        future: _images,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi khi tải dữ liệu: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Không có dữ liệu hình ảnh"));
          } else {
            final images = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,  // Hiển thị 2 cột
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final image = images[index];

                  return GestureDetector(
                    onTap: () {
                      // Khi nhấn vào hình ảnh, chuyển đến trang chi tiết
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassDetailPage(image),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                image.imageUrl,  // Dùng URL của ảnh từ API
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Lớp ${image.announcementId}', // Hiển thị thông tin lớp học
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

// Trang chi tiết lớp học khi nhấn vào
class ClassDetailPage extends StatelessWidget {
  final Images image;

  const ClassDetailPage(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lớp ${image.announcementId}"),
      ),
      body: Center(
        child: Image.network(image.imageUrl),  // Hiển thị ảnh chi tiết từ API
      ),
    );
  }
}


class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final Dio _dio = Dio();
  late ApiService _apiService;
  List<FeedbackModel> feedbacks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(_dio);
    _fetchFeedbacks();
  }

  Future<void> _fetchFeedbacks() async {
    try {
      final response = await _apiService.getFeedback();
      setState(() {
        feedbacks = response;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi khi lấy góp ý: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hòm thư")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Hiển thị loading
          : ListView.builder(
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          final feedback = feedbacks[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${feedback.createdAt}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feedback.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (feedback.imageUrl != null) ...[
                    const SizedBox(height: 8),
                    Image.network(
                      feedback.imageUrl!,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                  const SizedBox(height: 8),
                  const Text(
                    "Đã tiếp nhận",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFeedbackPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddFeedbackPage extends StatefulWidget {
  const AddFeedbackPage({super.key});

  @override
  _AddFeedbackPageState createState() => _AddFeedbackPageState();
}

class _AddFeedbackPageState extends State<AddFeedbackPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _contentController = TextEditingController();
  List<File> _images = [];

  // Hàm chọn ảnh từ thư viện hoặc camera
  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Chỉ được tải lên tối đa 5 ảnh")),
      );
      return;
    }

    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  // Hàm xóa ảnh đã chọn
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  // Hàm gửi góp ý lên server
  Future<void> _sendFeedback() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập nội dung góp ý")),
      );
      return;
    }

    try {
      final feedbackData = {
        "senderId": 3,
        "receiverId": 3,
        "content": _contentController.text,
        "status": "pending",
        "createdAt": DateTime.now().toIso8601String(),
        "images": [],
      };

      final dio = Dio();
      dio.options.headers["Content-Type"] = "application/json";
      final apiService = ApiService(dio);
      await apiService.sendFeedback(feedbackData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Góp ý đã được gửi thành công!")),
      );

      Navigator.pop(context);
    } catch (e) {
      String errorMessage = "Có lỗi xảy ra, vui lòng thử lại!";

      if (e is DioException) {
        errorMessage = "Lỗi: ${e.response?.statusCode} - ${e.response?.data}";
        print("Chi tiết lỗi: ${e.response?.data}");
      } else {
        print("Lỗi không xác định: $e");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gửi góp ý")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Thêm hình ảnh (tối đa 5 ảnh)"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _images.asMap().entries.map((entry) {
                int index = entry.key;
                File imageFile = entry.value;
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(imageFile, width: 100, height: 100, fit: BoxFit.cover),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () => _removeImage(index),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Chọn ảnh"),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Chụp ảnh"),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Nội dung *"),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập nội dung góp ý...',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Thông tin góp ý sẽ được gửi ẩn danh",
              style: TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _sendFeedback,
                child: const Text("Gửi"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}







class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final List<Map<String, String>> comments = [
    {"avatar": "assets/images/gopy.jpg", "name": "Nguyễn Văn A", "comment": "Bài học hôm nay thật thú vị!"},
    {"avatar": "assets/images/gopy.jpg", "name": "Trần Thị B", "comment": "Các con đã rất vui vẻ trong buổi học này!"},
  ];
  final TextEditingController _commentController = TextEditingController();

  void _addComment(String text) {
    if (text.isNotEmpty) {
      setState(() {
        comments.add({"avatar": "assets/images/gopy.jpg", "name": "Bạn", "comment": text});
      });
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 1.0, // Full screen
      builder: (_, controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Bình luận"),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(comment["avatar"]!),
                      ),
                      title: Text(comment["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(comment["comment"]!),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: "Nhập bình luận...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: () => _addComment(_commentController.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommentSection extends StatelessWidget {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Bình luận", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: "Nhập bình luận của bạn...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Gửi"),
          ),
        ],
      ),
    );
  }
}

