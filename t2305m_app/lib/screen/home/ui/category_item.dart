import 'package:dio/dio.dart';
import 'package:t2305m_app/api/api_service.dart';
import 'package:t2305m_app/models/feedback.dart';
import 'package:t2305m_app/models/schedule.dart';
import 'package:t2305m_app/models/messages.dart';
import 'package:t2305m_app/models/tuition.dart';
import 'package:t2305m_app/models/health.dart';

import 'package:flutter/material.dart';
import 'package:t2305m_app/model/category.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../models/study_comments.dart';
import '../../../models/study_results.dart';

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
      "assets/images/hoctap.png",
      "assets/images/suckhoe.png",
      "assets/images/thuvienanh.jpg",
      "assets/images/gopy.jpg",
    ];

    final List<String> imageLabels = [
      "Hoạt động",
      "Lời nhắn",
      "Điểm danh",
      "Học phí",
      "Học tập",
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

    // 🔹 **Lọc lịch học theo ngày được chọn**
    List<Schedule> filteredSchedules =
    schedules.where((s) => DateFormat('yyyy-MM-dd').format(s.dayOfWeek) == currentDate).toList();


    return Scaffold(
      appBar: AppBar(title: Text("Thời khóa biểu")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ngày: $currentDate", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 10),
                  _buildHorizontalDayList(),
                  SizedBox(height: 20),
                  Text("Thời khóa biểu:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  SizedBox(height: 10),
                  // Hiển thị tên môn học chính
                  // 🔹 Kiểm tra nếu có lịch học
                  filteredSchedules.isNotEmpty
                      ? Text(
                    filteredSchedules.first.subjectId, // Tên môn học
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.blue),
                  )
                      : Container(), // Nếu không có lịch, không hiển thị gì
                  SizedBox(height: 10),

// 🔹 Hiển thị danh sách lịch học từ API
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: filteredSchedules.map((schedule) {
                      return Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.book, color: Colors.blue), // Đổi icon thành sách 📖
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(schedule.subjectId, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Môn học
                                Text(
                                  "${DateFormat('HH:mm').format(schedule.startTime)} - ${DateFormat('HH:mm').format(schedule.endTime)} | GV: ${schedule.teacherId}",
                                  style: TextStyle(fontSize: 14),
                                ), // Thời gian học + mã giáo viên
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
    );
  }

  Widget _buildHorizontalDayList() {
    DateTime today = DateTime.now();
    List<Widget> dayWidgets = [];

    for (int i = 0; i < 7; i++) {
      DateTime currentDay = today.add(Duration(days: i));
      String formattedDate = DateFormat('dd/MM/yyyy').format(currentDay);
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
                  padding: EdgeInsets.all(12),
                  child: Text(
                    dayNumber,
                    style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 4),
                Text(DateFormat('EEE').format(currentDay), style: TextStyle(fontSize: 14)),
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
  final List<Map<String, String>> leaveRequests = [
    {
      "date": "28/06/2023",
      "reason": "Học sinh có vấn đề cá nhân",
      "status": "Chờ xác nhận",
      "time": "14:19",
    },
    {
      "date": "11/08/2022",
      "reason": "Con bị ốm",
      "status": "Chờ xác nhận",
      "time": "10:41",
    },
  ];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  final Map<String, Map<String, String>> attendanceData = {
    "Tháng 6/2023": {
      "Tất cả": "9",
      "Đi học": "9",
      "Nghỉ phép": "0",
      "Không phép": "0",
    },
    "26/06/2023 - 30/06/2023": {
      "Thứ 5 (29/06)": "Đi học",
      "Thứ 3 (27/06)": "Đi học",
      "Thứ 2 (26/06)": "Đi học",
    },
    "19/06/2023 - 25/06/2023": {
      "Thứ 6 (23/06)": "Đi học",
    },
  };

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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAttendanceTab(context),
          _buildLeaveRequestTab(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showLeaveRequestForm(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }


  Widget _buildAttendanceTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAttendanceSummary(context),
          SizedBox(height: 16),
          Expanded(child: _buildAttendanceDetails(context)),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestTab(BuildContext context) {
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
                Text("Ngày: ${request['date']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("Lý do: ${request['reason']}", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text("Trạng thái: ${request['status']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
                SizedBox(height: 8),
                Text("Gửi lúc: ${request['time']}", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttendanceSummary(BuildContext context) {
    final summary = attendanceData["Tháng 6/2023"];
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tháng 6/2023", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: summary!.entries.map((entry) {
              return Column(
                children: [
                  Text(entry.key, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 4),
                  Text(entry.value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceDetails(BuildContext context) {
    return ListView(
      children: attendanceData.entries
          .where((entry) => entry.key != "Tháng 6/2023")
          .map((entry) {
        final dateRange = entry.key;
        final details = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateRange, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: details.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key, style: TextStyle(fontSize: 16)),
                          Text(entry.value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }


  void _showLeaveRequestForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Thêm đơn xin nghỉ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Tên học sinh',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Ngày xin nghỉ',
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
                onPressed: () {
                  // Handle leave request submission
                  final leaveRequest = {
                    "date": _dateController.text,
                    "reason": _reasonController.text,
                    "status": "Chờ xác nhận",
                    "time": TimeOfDay.now().format(context),
                  };
                  setState(() {
                    leaveRequests.add(leaveRequest);
                  });
                  Navigator.pop(context);
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
  final List<String> _tuitionDetails = [
    "Chăm sóc bán trú: 330,000đ",
    "Hoạt động trải nghiệm: 100,000đ",
    "Học phẩm: 100,000đ",
    "Học phí 2 buổi/ngày: 50,000đ",
    "Học TA với GVNN: 500,000đ",
    "Học thêm 2 tháng - mới: 80,000đ",
    "Sữa học đường: 59.080",
    "Thứ 7: 12,000",
    "Tiền ăn bán trú",
    "Tiếng Anh Lets Go",
    "",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tiền học")),
      body: Padding(
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
                trailing: const Text(
                  "2,056,080₫",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                onTap: () {
                  // Xử lý khi bấm vào chi tiết
                },
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
              "5,179,160₫",
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
                itemCount: _tuitionDetails.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tuitionDetails[index]),
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
  const StudyPage({super.key});

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> with SingleTickerProviderStateMixin {
  late ApiService apiService;
  late TabController _tabController;

  List<StudyComment> studyComments = [];
  List<StudyResult> studyResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    _tabController = TabController(length: 2, vsync: this);
    fetchStudyComments();  // Lấy dữ liệu nhận xét
    fetchStudyResults();  // Lấy dữ liệu kết quả học tập
  }

  // Hàm để lấy dữ liệu StudyComment
  void fetchStudyComments() async {
    try {
      print("🟡 Gọi API: Lấy danh sách nhận xét học tập...");
      List<StudyComment> data = await apiService.getStudyComment();
      print("✅ Dữ liệu nhận được: $data");

      setState(() {
        studyComments = data;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Lỗi API StudyComments: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Hàm để lấy dữ liệu StudyResult
  void fetchStudyResults() async {
    try {
      print("🟡 Gọi API: Lấy danh sách kết quả học tập...");
      List<StudyResult> data = await apiService.getStudyResult();
      print("✅ Dữ liệu nhận được: $data");

      setState(() {
        studyResults = data;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Lỗi API StudyResults: $e");
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

  /// **Tab Nhận Xét**
  Widget _buildCommentsTab() {
    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    String yesterday = DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(Duration(days: 1)));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDateSection(today, [
          _buildCommentTile("Nhận xét ngày", "Con biết cất đồ chơi đúng nơi quy định", Icons.comment, Colors.blue),
          _buildCommentTile("Bữa ăn", "Con ăn hết suất", Icons.restaurant, Colors.orange),
          _buildCommentTile("Ngủ trưa", "Con có ý thức tự giác khi ngủ", Icons.bedtime, Colors.green),
          _buildCommentTile("Vệ sinh", "Con biết gọi cô khi buồn đi vệ sinh", Icons.wash, Colors.purple),
        ]),
        _buildDateSection(yesterday, [
          _buildCommentTile("Nhận xét ngày", "Con học thuộc bài hát rất nhanh", Icons.comment, Colors.blue),
          _buildCommentTile("Bữa ăn", "Con ăn giỏi", Icons.restaurant, Colors.orange),
          _buildCommentTile("Ngủ trưa", "Con ngủ bình thường", Icons.bedtime, Colors.green),
          _buildCommentTile("Vệ sinh", "Con đi vệ sinh bình thường", Icons.wash, Colors.purple),
        ]),
      ],
    );
  }

  /// **Tab Kết Quả Học Tập**
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

  /// **Chi tiết "Đánh giá"**
  Widget _buildEvaluationDetails() {
    return _buildDetailCard([
      _buildDetailRow("Tư duy logic", "Tốt"),
      _buildDetailRow("Tập trung", "Khá"),
      _buildDetailRow("Khả năng tiếp thu", "Rất tốt"),
      _buildDetailRow("Kỹ năng giao tiếp", "Tốt"),
    ]);
  }

  /// **Chi tiết "Chuyên cần"**
  Widget _buildAttendanceDetails() {
    return _buildDetailCard([
      _buildDetailRow("Số ngày đi học", "22 ngày"),
      _buildDetailRow("Số ngày nghỉ", "2 ngày"),
      _buildDetailRow("Đi học đúng giờ", "Rất tốt"),
    ]);
  }

  /// **Chi tiết "Phiếu bé ngoan"**
  Widget _buildGoodStudentDetails() {
    return _buildDetailCard([
      _buildDetailRow("Thái độ học tập", "Tích cực"),
      _buildDetailRow("Hợp tác với bạn bè", "Tốt"),
      _buildDetailRow("Tham gia hoạt động", "Nhiệt tình"),
    ]);
  }

  /// **Chi tiết "Nhìn kỳ HS"**
  Widget _buildProgressDetails() {
    return _buildDetailCard([
      _buildDetailRow("Tiến bộ môn Toán", "Rất tốt"),
      _buildDetailRow("Tiến bộ môn Tiếng Việt", "Khá"),
      _buildDetailRow("Thành tích cá nhân", "Có tiến bộ"),
    ]);
  }

  /// **Chi tiết "Nhật ký lớp"**
  Widget _buildClassDiaryDetails() {
    return _buildDetailCard([
      _buildDetailRow("Hoạt động học tập", "Thực hành vẽ tranh"),
      _buildDetailRow("Hoạt động vui chơi", "Trò chơi nhóm ngoài trời"),
      _buildDetailRow("Nhận xét chung", "Lớp học vui vẻ và tích cực"),
    ]);
  }

  /// **Widget chi tiết từng phần**
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

  /// **Widget hiển thị thông tin từng mục**
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

  /// **Widget danh sách nhận xét theo ngày**
  Widget _buildDateSection(String date, List<Widget> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ngày $date",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 3,
          child: Column(children: comments),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// **Widget danh sách nhận xét**
  Widget _buildCommentTile(String title, String content, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(content),
    );
  }

  /// **Widget danh sách kết quả học tập**
  Widget _buildResultTile(String title, IconData icon, Color color, Widget details) {
    return Card(
      elevation: 2,
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
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
class GrowthPage extends StatelessWidget {
  const GrowthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tăng trưởng")),
      body: Center(
        child: Text("Chi tiết Tăng trưởng sẽ được hiển thị ở đây."),
      ),
    );
  }
}

class HealthRecordsPage extends StatelessWidget {
  const HealthRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sổ sức khỏe")),
      body: Center(
        child: Text("Thông tin Sổ sức khỏe sẽ được hiển thị ở đây."),
      ),
    );
  }
}



class ContactsPage extends StatelessWidget {
  // Danh sách các lớp học và hình ảnh tương ứng
  final List<Map<String, String>> classes = const [
    {"name": "Lớp Tiếng Anh", "image": "assets/images/bangtin.png"},
    {"name": "Lớp Kỹ năng sống", "image": "assets/images/bangtin.png"},
    {"name": "Lớp Mỹ thuật – Sáng tạo", "image": "assets/images/bangtin.png"},
  ];

  const ContactsPage({super.key}); // Giữ từ khóa const ở đây

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thư viện ảnh")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,  // Hiển thị 2 cột
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final classData = classes[index];

            return GestureDetector(
              onTap: () {
                // Khi nhấn vào lớp học, chuyển đến một trang mới với ảnh chi tiết
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassDetailPage(classData),
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
                        child: Image.asset(
                          classData["image"]!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        classData["name"]!,
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
      ),
    );
  }
}

// Trang chi tiết lớp học khi nhấn vào
class ClassDetailPage extends StatelessWidget {
  final Map<String, String> classData;

  const ClassDetailPage(this.classData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(classData["name"]!),
      ),
      body: Center(
        child: Image.asset(classData["image"]!),
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
      appBar: AppBar(title: const Text("Hòm thư góp ý")),
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

