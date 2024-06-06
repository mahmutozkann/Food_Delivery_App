import 'package:sqflite/sqflite.dart';
import 'package:to_do_done/database/databaseHelper.dart';

class Food {
  final int? foodId;
  final String foodName;
  final String imagePath;
  final double price;

  Food({this.foodId, required this.foodName, required this.imagePath, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'imagePath': imagePath,
      'price': price,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      foodId: map['foodId'],
      foodName: map['foodName'],
      imagePath: map['imagePath'],
      price: map['price'],
    );
  }
}

class FoodRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertFood(Food food) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'foods',
      food.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Food>> getFoods() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('foods');

    return List.generate(maps.length, (i) {
      return Food.fromMap(maps[i]);
    });
  }

  Future<Food?> getFoodById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'foodId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Food.fromMap(maps.first);
    }
    return null;
  }
}
