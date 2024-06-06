import 'package:sqflite/sqflite.dart';
import 'package:to_do_done/database/databaseHelper.dart';

class Cart {
  final int? cartId;
  final int userId;
  final int foodId;
  final int quantity;

  Cart({this.cartId, required this.userId, required this.foodId, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId,
      'userId': userId,
      'foodId': foodId,
      'quantity': quantity,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
        cartId: json['cartId'],
        userId: json['userId'],
        foodId: json['foodId'],
        quantity: json['quantity'],
      );
}

class CartRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertCart(Cart cart) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'cart',
      cart.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Cart>> getCarts(int userId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cart',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Cart.fromMap(maps[i]);
    });
  }

  Future<void> clearCart(int userId) async {
    final db = await _databaseHelper.database;
    await db.delete('cart', where: 'userId = ?', whereArgs: [userId]);
  }
}
