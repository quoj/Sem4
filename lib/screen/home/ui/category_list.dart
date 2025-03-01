import 'package:flutter/material.dart';
import 'package:t2305m_flutter/screen/home/ui/category_item.dart';
import '../../../model/category.dart';
import '../../../service/category_service.dart';

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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Tính năng",
              style: TextStyle(
                color: Colors.red,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // GridView được bọc trong một Container hoặc SizedBox để có thể cuộn
          Container(
            height: MediaQuery.of(context).size.height, // Đảm bảo grid có thể cuộn
            child: GridView.builder(
              shrinkWrap: true, // Cho phép cuộn
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2, // Tăng tỉ lệ để ô rộng hơn
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
    );
  }
}


class BulletinWidget extends StatelessWidget {
  const BulletinWidget({super.key});

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
        height: 450, // Chiều cao để chứa nội dung
        child: Stack(
          clipBehavior: Clip.none, // Cho phép tràn
          children: [
            // Header "Bảng tin"
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
            // Author info
            Positioned(
              top: 60,
              left: 15,
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/gopy.jpg"), // Ảnh đại diện
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Cô giáo A",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "10:30 AM",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Post title
            const Positioned(
              top: 110,
              left: 15,
              child: Text(
                "Hoạt động hôm nay của các con",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Post content
            const Positioned(
              top: 140,
              left: 15,
              child: SizedBox(
                width: 320, // Đặt chiều rộng để tránh bị cắt
                child: Text(
                  "Hôm nay các con đã có buổi học rất thú vị về khoa học. Các con đã làm thí nghiệm với nước và màu sắc.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            // Image below content
            Positioned(
              top: 200,
              left: 15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/images/noithat.jpg",
                  width: 350,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Bottom Buttons (Like, Comment, Share)
            Positioned(
              top: 410,
              left: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, // Canh lề trái
                children: [
                  // Thích
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.grey),
                        onPressed: () {
                          // Thực hiện hành động thích
                        },
                      ),
                      const Text("Yêu thích"),
                    ],
                  ),
                  const SizedBox(width: 20), // Khoảng cách giữa các nút
                  // Bình luận
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment_outlined, color: Colors.grey),
                        onPressed: () {
                          // Hiển thị màn hình bình luận
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
                  const SizedBox(width: 20), // Khoảng cách giữa các nút
                  // Chia sẻ
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.green),
                        onPressed: () {
                          // Thực hiện hành động chia sẻ
                        },
                      ),
                      const Text("Chia sẻ"),
                    ],
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
  Map<int, bool> likedPosts = {};

  void toggleLike(int index) {
    setState(() {
      likedPosts[index] = !(likedPosts[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bảng tin")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildPost(
              context,
              index: 0,
              title: "Hoạt động hôm nay của các con",
              author: "Cô giáo A",
              content: "Hôm nay các con đã có buổi học rất thú vị về khoa học. Các con đã làm thí nghiệm với nước và màu sắc.",
              imagePath: "assets/images/noithat.jpg",
              time: "10:30 AM",
            ),
            _buildPost(
              context,
              index: 1,
              title: "Hoạt động ngoài trời",
              author: "Cô giáo B",
              content: "Các con đã có buổi chơi ngoài trời rất vui vẻ. Các con đã tham gia các trò chơi vận động như nhảy dây, đá bóng, và chạy đua.",
              imagePath: "assets/images/noithat.jpg",
              time: "2:00 PM",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPost(
      BuildContext context, {
        required int index,
        required String title,
        required String author,
        required String content,
        required String imagePath,
        required String time,
      }) {
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
            // Header: Avatar + Tên + Thời gian
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
                    Text(author, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Tiêu đề bài đăng
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            // Nội dung bài đăng
            Text(content),
            const SizedBox(height: 8),
            // Ảnh minh họa
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            // Nút Thích, Bình luận, Chia sẻ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Thích
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
                // Bình luận
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
                // Chia sẻ
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.green),
                      onPressed: () {},
                    ),
                    const Text("Chia sẻ"),
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