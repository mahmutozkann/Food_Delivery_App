import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_done/entities/food.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 7, // Veritabanı versiyonunu artırın
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        userId INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        firstName TEXT,
        lastName TEXT,
        email TEXT UNIQUE,
        password TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE foods (
        foodId INTEGER PRIMARY KEY AUTOINCREMENT,
        foodName TEXT,
        imagePath TEXT,
        price REAL
      )
      ''');

    await db.execute('''
      CREATE TABLE cart (
        cartId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        foodId INTEGER,
        quantity INTEGER,
        FOREIGN KEY(userId) REFERENCES users(userId),
        FOREIGN KEY(foodId) REFERENCES foods(foodId)
      )
      ''');

    // Örnek food verilerini ekleyelim
    await _insertSampleFoods(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Veritabanı versiyonu 1'den 2'ye yükseltildiğinde çalışacak kodlar
      await db.execute('''
        CREATE TABLE IF NOT EXISTS foods (
          foodId INTEGER PRIMARY KEY AUTOINCREMENT,
          foodName TEXT,
          imagePath TEXT,
          price REAL
        )
        ''');
    }
    if (oldVersion < 3) {
      // Yeni versiyon için örnek verileri ekleyelim
      await _insertSampleFoods(db);
    }
    if (oldVersion < 4) {
      // Yeni versiyon için örnek verileri ekleyelim
      await _insertSampleFoods(db);
    }
    if (oldVersion < 5) {
      // Yeni versiyon için örnek verileri ekleyelim
      await _insertSampleFoods(db);
    }
    if (oldVersion < 6) {
      // Yeni versiyon için örnek verileri ekleyelim
      await _insertSampleFoods(db);
    }
    if (oldVersion < 7) {
      // Tüm verileri sil ve yeniden ekle
      await db.delete('foods');
      await _insertSampleFoods(db);
    }
  }

  Future<void> _insertSampleFoods(Database db) async {
    List<Food> sampleFoods = [
      Food(
          foodName: 'Pizza',
          imagePath:
              'https://image-inciligastronomirehberi.hurriyet.com.tr/blog-desktop/06d231e7-37f9-a9fc-9b8e-62adaa454abb.jpg',
          price: 10.0),
      Food(
          foodName: 'Burger',
          imagePath:
              'https://www.shutterstock.com/image-photo/classic-hamburger-stock-photo-isolated-600nw-2282033179.jpg',
          price: 8.0),
      Food(
          foodName: 'Pasta',
          imagePath: 'https://i.lezzet.com.tr/images-xxlarge/salcali-makarna-f60e9ce7-6ad0-49ab-8dae-a3f6aa385734',
          price: 12.0),
      Food(
          foodName: 'Salad',
          imagePath: 'https://cdn.loveandlemons.com/wp-content/uploads/2021/04/green-salad.jpg',
          price: 6.0),
      Food(
          foodName: 'Sushi',
          imagePath: 'https://cdn.yemek.com/mnresize/940/940/uploads/2020/04/sushi-tarifi.jpg',
          price: 15.0),
      Food(foodName: 'Tacos', imagePath: 'https://www.onceuponachef.com/images/2023/08/Beef-Tacos.jpg', price: 9.0),
      Food(
          foodName: 'Ice Cream',
          imagePath:
              'https://www.allrecipes.com/thmb/SI6dn__pfJb9G5eBpYAqkyGCLxQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/50050-five-minute-ice-cream-DDMFS-4x3-076-fbf49ca6248e4dceb3f43a4f02823dd9.jpg',
          price: 5.0),
      Food(
          foodName: 'Sandwich',
          imagePath:
              'https://assets.bonappetit.com/photos/62b1f659a38f8b1339b88af8/1:1/w_2560%2Cc_limit/20220615-0622-sandwiches-1746-final%2520(1).jpg',
          price: 7.0),
      Food(
          foodName: 'Soup',
          imagePath:
              'https://www.177milkstreet.com/assets/site/Recipes/_large/Indian-Style-Tomato-Ginger-Soup-Cook-What-You-Have-Milk-Street.jpg',
          price: 4.0),
    ];

    for (var food in sampleFoods) {
      await db.insert('foods', food.toMap());
    }
  }
}
