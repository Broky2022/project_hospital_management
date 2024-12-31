import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> showData(String xp) async {
  try {
    // Mở kết nối đến cơ sở dữ liệu
    final db = await openDatabase(
      join(await getDatabasesPath(), 'medical_app.db'),
    );

    List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$xp';", //đổi tên ở đây
    );

    if (tables.isEmpty) {
      print("Bảng không tồn tại.");
      return;
    }

    List<Map<String, dynamic>> data = await db.query('$xp'); //và ở đây!

    // Kiểm tra dữ liệu và in ra console
    if (data.isEmpty) {
      print("Không có dữ liệu trong bảng.");
    } else {
      print("Dữ liệu trong bảng:");
      for (var row in data) {
        print(row);
      }
    }
  } catch (e) {
    // Xử lý lỗi
    print("Lỗi: $e");
  }
}
