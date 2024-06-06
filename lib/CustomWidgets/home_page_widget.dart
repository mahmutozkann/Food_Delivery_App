import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:to_do_done/entities/cart.dart';
import 'package:to_do_done/entities/food.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final FoodRepository _foodRepository = FoodRepository();
  final CartRepository _cartRepository = CartRepository();
  List<Food> _foods = [];
  final String _title = 'Choose Your Food';
  String _hiUser = 'Hi User!';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFoods();
    _getUsername();
  }

  Future<void> _fetchFoods() async {
    try {
      final foods = await _foodRepository.getFoods();
      setState(() {
        _foods = foods;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    setState(() {
      _hiUser = username != null ? 'Hi $username!' : 'Hi User!';
      _isLoading = false;
    });
  }

  Future<void> _addToCart(Food food) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found. Please log in again.')),
      );
      return;
    }

    Cart cartItem = Cart(userId: userId, foodId: food.foodId!, quantity: 1);

    await _cartRepository.insertCart(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${food.foodName} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
        ),
        title: Text(_title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Text(
                    _hiUser,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          _foods.isNotEmpty
              ? SliderWidget(foods: _foods, addToCart: _addToCart)
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class SliderWidget extends StatelessWidget {
  const SliderWidget({Key? key, required this.foods, required this.addToCart}) : super(key: key);

  final List<Food> foods;
  final Function(Food) addToCart;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 275,
      child: InfiniteCarousel.builder(
        itemCount: foods.length,
        itemExtent: 220,
        anchor: 0.0,
        center: true,
        velocityFactor: 0.2,
        onIndexChanged: (index) {},
        axisDirection: Axis.horizontal,
        loop: true,
        itemBuilder: (context, itemIndex, realIndex) {
          final food = foods[itemIndex];
          return FoodInfoWidget(
            foodNameTitle: food.foodName,
            imageUrl: food.imagePath,
            price: food.price,
            onAddToCart: () => addToCart(food),
          );
        },
      ),
    );
  }
}

class FoodInfoWidget extends StatelessWidget {
  const FoodInfoWidget({
    Key? key,
    required this.foodNameTitle,
    required this.imageUrl,
    required this.price,
    required this.onAddToCart,
  }) : super(key: key);

  final String foodNameTitle;
  final String imageUrl;
  final double price;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, // Kart genişliğini ayarlayın
      margin: const EdgeInsets.symmetric(horizontal: 8), // Kartlar arasında boşluk ekleyin
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 3, blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              imageUrl,
              height: 130, // Resim kutusu yüksekliğini belirleyin
              width: double.infinity, // Resim kutusu genişliğini kartın genişliğiyle aynı yapın
              fit: BoxFit.cover, // Resmi uygun şekilde boyutlandırın
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8), // Tüm yönlere padding ekleyin
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodNameTitle,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2, // Metni maksimum iki satıra kısaltın
                  overflow: TextOverflow.ellipsis, // Metni taşma durumunda kısaltın
                ),
                const SizedBox(height: 4),
                const SizedBox(height: 6),
              ],
            ),
          ),
          Spacer(), // İçeriğin geri kalanını doldur
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Alt ve yanlardan padding ekleyin
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$$price',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green[400]),
                ),
                IconButton(
                  onPressed: onAddToCart,
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.green[400],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
