import 'package:flutter/material.dart';
import 'package:t2305m_app/model/category.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

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
                  fontSize: 15,
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
  String? avatarPath;
  DateTime selectedDate = DateTime.now();

  final Map<String, List<String>> scheduleByDate = {
    "26/01/2025": ["8:00 AM - Toán học", "10:00 AM - Lập trình"],
    "11/01/2025": ["1:00 PM - Kỹ thuật phần mềm", "3:00 PM - Hệ thống thông tin"],
    "12/01/2025": ["8:30 AM - Cơ sở dữ liệu", "2:00 PM - Quản lý dự án"]
  };

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    List<String> schedule = scheduleByDate[currentDate] ?? ["Không có lịch học"];

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

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: schedule.map((subject) {
                      return Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow.shade700),
                            SizedBox(width: 10),
                            Text(subject, style: TextStyle(fontSize: 16)),
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



class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lời nhắn")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
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
                      Text("28/06/2023",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("10:26",
                          style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Con bị ốm, nhờ cô quan tâm hơn đến con",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Image.asset(
                    "assets/images/bangtin.png",
                    height: 150,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Cô Nguyễn Thị Hồng Anh đã xác nhận",
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  // Chuyển đến trang Thêm lời nhắn
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddMessagePage()),
                  );
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
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
  File? _selectedImage; // Lưu trữ ảnh đã chọn

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path); // Lưu ảnh đã chọn
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm lời nhắn"),
      ),
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
                  icon: Icon(Icons.calendar_today),
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
            SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage, // Gọi hàm chọn ảnh
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
                  children: [
                    Icon(Icons.image, size: 50, color: Colors.grey),
                    Text("Thêm hình ảnh",
                        style: TextStyle(color: Colors.grey)),
                  ],
                )
                    : Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Nội dung *",
                hintText:
                "Nhập lời nhắn muốn gửi đến giáo viên (VD: nhờ cô giáo lưu ý về sức khỏe của con, cho con uống thuốc...)",
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý khi nhấn nút Gửi
                  print("Ngày: ${_dateController.text}");
                  print("Nội dung: ${_messageController.text}");
                  print("Hình ảnh: ${_selectedImage?.path}");
                },
                child: Text("Gửi"),
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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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



class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sức khỏe")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 20),
            _buildHealthOptions(context),
            const SizedBox(height: 20),
            _buildHealthNotes(),
          ],
        ),
      ),
    );
  }

  /// **Widget Thông tin cá nhân và sức khỏe**
  Widget _buildProfileCard() {
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
                  backgroundImage: AssetImage("assets/images/bangtin.png"), // Ảnh đại diện
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Đinh Việt Trung",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Text("21/06/2021", style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 8),
                        Icon(Icons.male, color: Colors.blue, size: 18),
                        Text(" Nam", style: TextStyle(color: Colors.blue)),
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
                _buildHealthStat("24", "Tháng tuổi"),
                _buildHealthStat("89 cm", "Chiều cao"),
                _buildHealthStat("14 kg", "Cân nặng"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// **Widget Hiển thị chỉ số sức khỏe**
  Widget _buildHealthStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  /// **Widget "Tăng trưởng" và "Sổ sức khỏe"**
  Widget _buildHealthOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHealthButton(Icons.show_chart, "Tăng trưởng", () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const GrowthPage()));
        }),
        _buildHealthButton(Icons.health_and_safety, "Sổ sức khỏe", () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthRecordsPage()));
        }),
      ],
    );
  }

  /// **Widget Nút Chức Năng**
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

  /// **Widget "Lưu ý sức khỏe của bé"**
  Widget _buildHealthNotes() {
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
            const Text(
              "Thêm lưu ý cho giáo viên về các vấn đề sức khỏe của con\n- Ví dụ: Dị ứng hải sản",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

/// **📌 Trang "Tăng trưởng" (Chiều cao & Cân nặng)**


class GrowthPage extends StatelessWidget {
  const GrowthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tăng trưởng")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text("Chiều cao học sinh lớp Mầm 1", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildGrowthRecord("01/2024", "87 cm", "13.5 kg"),
            _buildGrowthRecord("02/2024", "88 cm", "13.8 kg"),
            _buildGrowthRecord("03/2024", "89 cm", "14 kg"),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthRecord(String date, String height, String weight) {
    return Card(
      elevation: 3,
      child: ListTile(
        title: Text("Ngày: $date"),
        subtitle: Text("Chiều cao: $height | Cân nặng: $weight"),
      ),
    );
  }
}

class HeightChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black;

    final heightData = [87.0, 88.0, 89.0]; // Dữ liệu chiều cao
    final minX = 0;
    final maxX = heightData.length - 1;
    final minY = 87.0;
    final maxY = 89.0;

    // Draw the grid
    for (int i = minY.toInt(); i <= maxY; i++) {
      final y = size.height * (1 - (i - minY) / (maxY - minY));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (int i = minX; i <= maxX; i++) {
      final x = size.width * (i - minX) / (maxX - minX);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw the line chart
    final path = Path();
    for (int i = 0; i < heightData.length; i++) {
      final x = size.width * i / (heightData.length - 1);
      final y = size.height * (1 - (heightData[i] - minY) / (maxY - minY));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;
    paint.color = Colors.blue;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


/// **📌 Trang "Sổ sức khỏe" (Lịch sử khám & hồ sơ)**


class HealthRecordsPage extends StatelessWidget {
  const HealthRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sổ sức khỏe"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Khám định kỳ"),
              Tab(text: "Hồ sơ sức khỏe"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PeriodicCheckupPage(),
            HealthProfilePage(),
          ],
        ),
      ),
    );
  }
}

class PeriodicCheckupPage extends StatelessWidget {
  const PeriodicCheckupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Lịch sử khám sức khỏe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildHealthRecord("15/01/2024", "Khám tổng quát", "Bình thường"),
          _buildHealthRecord("20/02/2024", "Tiêm phòng cúm", "Hoàn thành"),
          _buildHealthRecord("10/03/2024", "Kiểm tra dinh dưỡng", "Đủ tiêu chuẩn"),
        ],
      ),
    );
  }

  Widget _buildHealthRecord(String date, String type, String status) {
    return Card(
      elevation: 3,
      child: ListTile(
        title: Text("Ngày: $date"),
        subtitle: Text("$type - Trạng thái: $status"),
      ),
    );
  }
}

class HealthProfilePage extends StatelessWidget {
  const HealthProfilePage({super.key});

  String _getFormattedDate(int daysAgo) {
    final date = DateTime.now().subtract(Duration(days: daysAgo));
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Hồ sơ sức khỏe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildHealthRecord(_getFormattedDate(1), "Chiều cao", "Đạt 89 cm", Icons.height, Colors.blue),
          _buildHealthRecord(_getFormattedDate(2), "Cân nặng", "Tăng 0.5 kg", Icons.fitness_center, Colors.red),
          _buildHealthRecord(_getFormattedDate(3), "Sức khỏe tổng quát", "Bình thường", Icons.check_circle, Colors.green),
        ],
      ),
    );
  }

  Widget _buildHealthRecord(String date, String type, String status, IconData icon, Color iconColor) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text("Ngày: $date"),
        subtitle: Text("$type - Trạng thái: $status"),
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


class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hòm thư góp ý")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "10:22, 28/06/2023",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Sàn lớp học có đoạn trơn trượt dễ bị ngã. Mong nhà trường lưu ý thêm vấn đề này.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Image.asset('assets/images/noithat.jpg'), // Hiển thị ảnh từ assets
            const SizedBox(height: 8),
            const Text(
              "Đã tiếp nhận",
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ],
        ),
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

            // Hiển thị danh sách ảnh đã chọn
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

            // Nút chọn ảnh
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
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập nội dung góp ý...',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Thông tin góp ý, phản ánh của phụ huynh sẽ được gửi tới nhà trường dưới hình thức giấu tên",
              style: TextStyle(color: Colors.grey),
            ),
            const Spacer(),

            // Nút gửi góp ý
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý khi nhấn nút "Gửi"
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Góp ý đã được gửi!")),
                  );
                },
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

