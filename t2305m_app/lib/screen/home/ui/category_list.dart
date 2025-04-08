import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:t2305m_app/screen/home/ui/category_item.dart';
import '../../../api/api_service.dart';
import '../../../model/category.dart';
import '../../../service/category_service.dart';
import '../../../models/announcements.dart';
import '../../../service/announcement_service.dart';
class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    final categoryService = CategoryService();
    final fetchedCategories = await categoryService.getCategories();
    print(fetchedCategories);

    setState(() {
      categories = fetchedCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container( // Đặt nền trắng bao toàn bộ giao diện
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Đặt nền trắng cho tiêu đề "Tính năng"
            Container(
              width: double.infinity, // Tránh bị cắt ngang
              color: Colors.white, // Nền trắng
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Tính năng",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // GridView với nền trắng
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemCount: categories.length > 8 ? 9 : categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 8 || (categories.isNotEmpty && index == categories.length)) {
                    return const BulletinWidget(); // Bảng tin
                  }
                  if (categories.isEmpty) return Container();
                  return CategoryItem(
                    category: categories[index],
                    imageIndex: index,
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


class BulletinWidget extends StatefulWidget {
  const BulletinWidget({super.key});

  @override
  _BulletinWidgetState createState() => _BulletinWidgetState();
}

class _BulletinWidgetState extends State<BulletinWidget> {
  late ApiService apiService;
  List<Announcement> announcements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    fetchAnnouncements();
  }

  void fetchAnnouncements() async {
    try {
      List<Announcement> data = await apiService.getAnnouncements();
      setState(() {
        announcements = data;
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BulletinPage()),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 450,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned(
              top: 5,
              left: 5,
              child: Text(
                "Bảng tin",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : announcements.isEmpty
                ? const Center(child: Text("Không có thông báo nào"))
                : Positioned(
              top: 60,
              left: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/gopy.jpg"),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcements[0].author,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            announcements[0].createdAt,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    announcements[0].title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 340,
                    child: Text(
                      announcements[0].content,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      announcements[0].imagePath,
                      width: 350,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, size: 100);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class BulletinPage extends StatefulWidget {
  const BulletinPage({super.key});

  @override
  _BulletinPageState createState() => _BulletinPageState();
}

class _BulletinPageState extends State<BulletinPage> {
  late ApiService apiService;
  List<Announcement> announcements = [];
  bool isLoading = true;
  Map<int, bool> likedPosts = {};

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    fetchAnnouncements();
  }

  void fetchAnnouncements() async {
    try {
      List<Announcement> data = await apiService.getAnnouncements();
      setState(() {
        announcements = data;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi API: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleLike(int index) {
    setState(() {
      likedPosts[index] = !(likedPosts[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bảng tin")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : announcements.isEmpty
          ? const Center(child: Text("Không có thông báo nào"))
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          return _buildPost(context, index, announcements[index]);
        },
      ),
    );
  }

  Widget _buildPost(BuildContext context, int index, Announcement announcement) {
    bool isLiked = likedPosts[index] ?? false;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/gopy.jpg"),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(announcement.author, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text(announcement.createdAt, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(announcement.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(announcement.content, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                announcements[0].imagePath,
                width: 350,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 100);
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => toggleLike(index),
                    ),
                    Text(isLiked ? "Đã yêu thích" : "Yêu thích"),
                  ],
                ),
                const SizedBox(width: 100),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.comment_outlined, color: Colors.grey),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => const CommentScreen(),
                        );
                      },
                    ),
                    const Text("Bình luận"),
                  ],
                ),
              ],
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
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, String>> _comments = [
    {"name": "Người dùng 1", "comment": "Bài viết rất hay!"},
    {"name": "Người dùng 2", "comment": "Cảm ơn cô giáo đã chia sẻ!"},
    {"name": "Người dùng 3", "comment": "Các bé học rất giỏi!"}
  ];

  void _addComment() {
    final commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      setState(() {
        _comments.add({"name": "Bạn", "comment": commentText});
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/gopy.jpg"),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _comments[index]["name"]!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _comments[index]["comment"]!,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Nhập bình luận...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}