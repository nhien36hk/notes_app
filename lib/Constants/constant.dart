import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/models/note_model.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;


  List<NoteModel> ExampleNote = [
    NoteModel(
      title: 'Ý tưởng quà tặng cho mẹ',
      note: '1. Hộp trang sức\n2. Sách nấu ăn\n3. Khăn quàng cổ\n4. Thẻ quà tặng cho ngày spa',
      date: '2025-02-14 15:53:58',
    ),
    NoteModel(
      title: 'Kế hoạch tập luyện',
      note: 'Thứ Hai: Chạy 5 dặm\nThứ Ba: Tập HIIT\nThứ Tư: Bơi\nThứ Năm: Nghỉ ngơi\nThứ Sáu: Tập tạ\nThứ Bảy: Leo núi',
      date: '2025-02-14 16:20:22',
    ),
    NoteModel(
      title: 'Danh sách mua sắm',
      note: '1. Sách\n2. Đồ gia dụng\n3. Quần áo\n4. Quà cho bạn bè',
      date: '2025-02-15 10:30:00',
    ),
    NoteModel(
      title: 'Kế hoạch du lịch',
      note: 'Thành phố: Hà Nội\nMốc thời gian: Tháng 5\nĐiểm đến: Hồ Hoàn Kiếm, Văn Miếu',
      date: '2025-02-16 09:45:00',
    ),
    NoteModel(
      title: 'Mục tiêu năm 2025',
      note: '1. Tiết kiệm 50 triệu\n2. Học lập trình\n3. Đọc 12 cuốn sách\n4. Du lịch ít nhất 3 nước',
      date: '2025-02-16 12:00:00',
    ),
    NoteModel(
      title: 'Ghi chú học tập',
      note: '1. Đọc sách giáo trình\n2. Làm bài tập\n3. Ôn thi môn Lập trình\n4. Thực hành Code',
      date: '2025-02-16 14:30:00',
    ),
    NoteModel(
      title: 'Công việc cần làm',
      note: '1. Gửi email cho khách hàng\n2. Cập nhật báo cáo tài chính\n3. Lên kế hoạch cho dự án mới\n4. Họp với đội nhóm',
      date: '2025-02-17 08:30:00',
    ),
    NoteModel(
      title: 'Bài học kinh doanh',
      note: '1. Tập trung vào khách hàng\n2. Không ngừng cải tiến\n3. Học hỏi từ đối thủ\n4. Lập kế hoạch tài chính rõ ràng',
      date: '2025-02-17 11:00:00',
    ),
    NoteModel(
      title: 'Thói quen sức khỏe',
      note: '1. Uống đủ nước mỗi ngày\n2. Ngủ đủ giấc\n3. Tập thể dục đều đặn\n4. Ăn uống lành mạnh',
      date: '2025-02-18 13:00:00',
    ),
    NoteModel(
      title: 'Danh sách các bộ phim yêu thích',
      note: '1. The Matrix\n2. Inception\n3. Interstellar\n4. The Dark Knight',
      date: '2025-02-18 16:45:00',
    ),
  ];